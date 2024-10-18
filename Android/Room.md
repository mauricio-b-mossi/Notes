### Important points about room.

This covers important aspects of Room Database in Android.

###### [Entities](https://developer.android.com/training/data-storage/room/defining-data)

@Entity

- By default the name of the database table is the name of the class annotated with `@Entity`.
- By default the name of the columns in the database are the names of the properties in the `@Entity`.
- Each `@Entity` must include at least one primary key, either by annotation the field with `@PrimaryKey`.
  or is your primary key is the combination of multiple columns, use the `primaryKeys` property in the `@Entity` annotation.
- To ignore a field use the `@Ignore` property. To ignore fields from a subclass use `ignoredColumns` property in the `@Entity` annotation.
- Can provide Google-like search support using SQLite `FTS3` or `FTS4`.
- Can index columns for faster search using `indices` property within the `@Entity` annotation: It is a trade-off between speed and space.
- Can set uniqueness property to values in `@Index` by using property `unique`.

###### [Daos](https://developer.android.com/training/data-storage/room/accessing-data)

@Dao

- Can be either interface or abstract class: Usually use interface.
- Daos do not have properties, they just define methods for interacting with data.
- There are two types of methods in Dao:
  - Convenience methods: Insert, Update, Delete, does not require a written query.
  - Query methods: Query, requires a written query.
    |Annotation|Type|Description|
    |---|---|---|
    |`@Insert`|Convenience|Each parameter for an `@Insert` method must be an instance or collection of the Room data entity class(es) `@Entity`. Returns a `long` containing the `rowId`.|
    |`@Update`|Convenience|Similar to `@Insert` accets instances of Room data entity class, it uses the primary key to update values.|
    |`@Delete`|Convenience|Similar to the above, accepts entity classes as parameters, it uses the primary key to delete values, can return a `int` indicating the number of rows deleted.|
    |[`@Query`](https://developer.android.com/training/data-storage/room/accessing-data#query)|Query|Read Docs, to Complex.|
