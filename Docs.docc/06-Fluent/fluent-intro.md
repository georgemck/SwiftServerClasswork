# Introduction

@Metadata {
    @PageKind(article)
    @PageColor(blue)
    @SupportedLanguage(swift)
}

Create a Fluent model and migration for a Poll.

## Objectives

Modern server applications frequently require the ability to connect to external databases. By the end of this lab, you
will understand how to:

- Create a Swift service to persist data in a SQLite database.
- Create a Fluent migration to save data to a `Poll` table.
- Create Fluent models to interact with SQLite tables.

## What is Fluent?

Fluent enables you to leverage relational databases without writing detailed SQL syntax. Fluent is an object-relational
mapper (ORM) that translates database data into Swift objects.
