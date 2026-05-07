---
title: "API-First with OpenAPI Generator: From Spec to REST API and Type-Safe SDKs"
url: "https://dev.to/malkomich/api-first-with-openapi-generator-from-spec-to-rest-api-and-type-safe-sdks-4gl2"
author: "Juan Carlos González Cabrero"
category: "templatized-software"
---
# API-First with OpenAPI Generator: From Spec to REST API and Type-Safe SDKs
**Author:** Juan Carlos González Cabrero  **Published:** January 22, 2026

## Overview
A comprehensive guide exploring the contract-first approach to API development, where an OpenAPI specification serves as the foundational contract before any implementation code is written. Demonstrates how tools like OpenAPI Generator and Maven can transform a single YAML specification into production-grade Java REST backends and type-safe SDK clients across multiple programming languages.

## Key Concepts
- **Contract-First Approach**: Define API contract upfront, preventing drift between client and server implementations and providing compile-time validation
- **Generated Server Code**: The `spring` generator creates Java interfaces (when `interfaceOnly: true`) and model classes with validation annotations
- **Generated Client SDKs**: Same spec generates type-safe clients in Java, TypeScript, Python, Go, etc. All clients automatically stay synchronized with server changes
- **Maven Plugin Configuration**: `openapi-generator-maven-plugin` orchestrates code generation with separate executions for server interfaces, models, and client SDKs
- **Bean Validation Integration**: Constraints from the OpenAPI spec become Hibernate Validator annotations on generated model classes

```yaml
openapi: 3.0.3
info:
  title: Bookstore API
  version: 1.0.0
paths:
  /books:
    get:
      summary: List all books
      responses:
        '200':
          description: A list of books
          content:
            application/json:
              schema:
                type: array
                items:
                  $ref: '#/components/schemas/Book'
    post:
      summary: Add a new book
      requestBody:
        required: true
        content:
          application/json:
            schema:
              $ref: '#/components/schemas/BookRequest'
      responses:
        '201':
          description: Book created
components:
  schemas:
    Book:
      type: object
      required: [id, title, author]
      properties:
        id:
          type: string
          format: uuid
        title:
          type: string
        author:
          type: string
    BookRequest:
      type: object
      required: [title, author]
      properties:
        title:
          type: string
          minLength: 1
        author:
          type: string
        price:
          type: number
          minimum: 1
```

```xml
<plugin>
  <groupId>org.openapitools</groupId>
  <artifactId>openapi-generator-maven-plugin</artifactId>
  <version>7.12.0</version>
  <executions>
    <execution>
      <id>code-generate-spring</id>
      <goals><goal>generate</goal></goals>
      <configuration>
        <inputSpec>${project.basedir}/src/main/resources/bookstore-api.yaml</inputSpec>
        <generatorName>spring</generatorName>
        <apiPackage>com.bookstore.api</apiPackage>
        <modelPackage>com.bookstore.model</modelPackage>
        <library>spring-boot</library>
        <configOptions>
          <reactive>true</reactive>
          <interfaceOnly>true</interfaceOnly>
          <useBeanValidation>true</useBeanValidation>
        </configOptions>
      </configuration>
    </execution>
  </executions>
</plugin>
```

```java
@RestController
public class BooksController implements BooksApi {
    @Override
    public ResponseEntity<List<Book>> getBooks() {
        List<Book> books = bookRepository.findAll();
        return ResponseEntity.ok(books);
    }

    @Override
    public ResponseEntity<Book> addBook(BookRequest bookRequest) {
        Book createdBook = bookService.addBook(bookRequest);
        return ResponseEntity.status(201).body(createdBook);
    }
}
```

```yaml
name: API Contract Validation
on: [push, pull_request]
jobs:
  validate:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v3
      - name: Generate OpenAPI code
        run: mvn clean generate-sources
      - name: Check for uncommitted changes
        run: |
          git diff --exit-code target/generated-sources/openapi
```
