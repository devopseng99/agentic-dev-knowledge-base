---
title: "AI Agent for Database Management: Automating SQL Operations with Natural Language"
url: "https://dev.to/vishalmysore/ai-agent-for-database-management-automating-sql-operations-with-natural-language-2f67"
author: "vishalmysore"
category: "ai-agent-database-query"
---

# AI Agent for Database Management: Automating SQL Operations with Natural Language

**Author:** vishalmysore
**Published:** January 27, 2025

## Overview
Demonstrates how AI agents simplify database management by performing operations like creating databases, tables, inserting data, and retrieving information through natural English statements using the Tools4AI framework with Apache Derby.

## Key Concepts

### Dynamic Action Mapping
- Prompt: "Hey, I need to maintain a record of employees with title and name."
- Generated SQL: `CREATE TABLE employees (name VARCHAR(255), title VARCHAR(255));`

- Prompt: "Insert a record for Sanjay Kapoor, who joined today as a Chef."
- Generated SQL: `INSERT INTO employees (name, title) VALUES ('Sanjay Kapoor', 'Chef');`

### TableData Class Structure
```java
package io.github.vishalmysore.data;

import com.t4a.annotations.ListType;
import lombok.Getter;
import lombok.Setter;
import lombok.ToString;

import java.util.ArrayList;
import java.util.List;

@Getter
@Setter
@ToString
public class TableData {
    private String tableName;
    @ListType(ColumnData.class)
    private List<ColumnData> headerList;
    @ListType(RowData.class)
    private List<RowData> rowDataList;
}
```

### Service Implementation
```java
package io.github.vishalmysore.service;

import com.t4a.annotations.Action;
import com.t4a.annotations.Agent;
import io.github.vishalmysore.data.ColumnData;
import io.github.vishalmysore.data.RowData;
import io.github.vishalmysore.data.TableData;
import io.github.vishalmysore.data.User;
import lombok.extern.java.Log;
import org.springframework.stereotype.Service;

import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Log
@Service
@Agent(groupName = "Database related actions")
public class DerbyService {
    private static final String JDBC_URL = "jdbc:derby:memory:myDB;create=true";
    private static final String JDBC_DRIVER = "org.apache.derby.jdbc.ClientDriver";

    @Action(description = "Create tables")
    public String createTables(TableData tableData) {
        // Implementation details...
    }
}
```

### Technologies
- **Java:** Primary programming language
- **Spring Boot:** Application framework
- **Apache Derby:** In-memory relational database
- **Tools4AI:** Framework enabling AI-based actions

**GitHub:** https://github.com/vishalmysore/SqlAIAgent
