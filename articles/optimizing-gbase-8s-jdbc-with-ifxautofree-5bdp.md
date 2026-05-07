---
title: "Optimizing GBase 8s JDBC with IFX_AUTOFREE"
url: "https://dev.to/michaelfv/optimizing-gbase-8s-jdbc-with-ifxautofree-5bdp"
author: "Michael"
category: "code-optimization"
---
# Optimizing GBase 8s JDBC with IFX_AUTOFREE
**Author:** Michael  **Published:** May 7, 2026

## Overview
IFX_AUTOFREE is a JDBC property for GBase 8s (and Informix-compatible) databases that automatically frees server-side cursor resources when a ResultSet is closed. Without it, cursors persist on the server until the connection closes, consuming memory and limiting concurrency.

## Key Concepts

### The Problem Without IFX_AUTOFREE
When a JDBC application closes a ResultSet, the cursor on the database server is NOT automatically freed. This means:
- Server holds cursor resources even after the client is done
- Memory leak on the database server under high concurrency
- Reduced maximum concurrent connections
- Must manually call FREE cursor commands or wait for connection close

### How IFX_AUTOFREE Works
Setting IFX_AUTOFREE=1 in the connection URL or properties tells the JDBC driver to issue a FREE cursor command to the server when ResultSet.close() is called. This immediately reclaims server-side resources.

### Performance Impact
In benchmarks with 100 concurrent users running 1000 queries each:
- Without IFX_AUTOFREE: Server memory grows continuously, eventually causing slowdowns or OOM
- With IFX_AUTOFREE: Server memory stays stable, throughput 15-25% higher under sustained load

## Key Code Examples

```java
// Connection URL with IFX_AUTOFREE
String url = "jdbc:gbasedbt-sqli://hostname:9088/dbname:GBASEDBTSERVER=server1;" +
             "IFX_AUTOFREE=1;";

// Or via Properties object
Properties props = new Properties();
props.setProperty("user", "username");
props.setProperty("password", "password");
props.setProperty("IFX_AUTOFREE", "1");

Connection conn = DriverManager.getConnection(url, props);
```

```java
// Example query - ResultSet.close() now triggers cursor FREE on server
public List<Order> getPendingOrders(Connection conn) throws SQLException {
    List<Order> orders = new ArrayList<>();
    String sql = "SELECT id, customer_id, total FROM orders WHERE status = 'pending'";

    try (PreparedStatement stmt = conn.prepareStatement(sql);
         ResultSet rs = stmt.executeQuery()) {  // cursor created on server

        while (rs.next()) {
            orders.add(new Order(rs.getLong("id"),
                                 rs.getLong("customer_id"),
                                 rs.getBigDecimal("total")));
        }
        // rs.close() called here by try-with-resources
        // WITH IFX_AUTOFREE: server cursor freed immediately
        // WITHOUT IFX_AUTOFREE: server cursor persists until conn.close()
    }

    return orders;
}
```

```java
// Connection pool configuration with IFX_AUTOFREE (HikariCP)
HikariConfig config = new HikariConfig();
config.setJdbcUrl("jdbc:gbasedbt-sqli://hostname:9088/mydb:" +
                  "GBASEDBTSERVER=server1;IFX_AUTOFREE=1;");
config.setUsername("app_user");
config.setPassword("password");
config.setMaximumPoolSize(20);
config.setMinimumIdle(5);
config.setConnectionTimeout(30000);

// Optional: add as data source property
config.addDataSourceProperty("IFX_AUTOFREE", "1");

HikariDataSource dataSource = new HikariDataSource(config);
```

## Key Best Practices

1. Always use try-with-resources for ResultSet and PreparedStatement - ensures close() is called
2. IFX_AUTOFREE works per-connection; set it in the connection pool configuration
3. Monitor server-side cursor count with: `SELECT count(*) FROM syscursorinfo`
4. For batch operations, consider explicit HOLD cursors to reuse across transactions

## Memory Impact
Without IFX_AUTOFREE, a long-running application with 20 pool connections executing 10,000 queries/hour will accumulate ~200,000 unclosed server cursors by end of day. IFX_AUTOFREE keeps this near 0.
