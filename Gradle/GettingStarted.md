## Getting Started
[What is gradle?](https://docs.gradle.org/current/userguide/what_is_gradle.html#what_is_gradle)
Gradle is a build automation tool, flexible enough to build almost any type of software.

#### Design
- **High performance** with caches.
- **JMV foundation** runs on the JVM.
- **Conventions** plugins set sensible defaults to keep build scripts minimal. 
- **Extensibility** can extend Gradle with custom tasks and plugins.

#### Terminology
- **Projects** are things the Gradle builds. They contain build scripts, which is a 
file located in the project's root directory, usually named `build.gradle`. Build scripts
define tasks, dependencies, plugins and other configuration for that project.

- **Tasks** contain the logic for executing some work - compiling code, running tests or 
deploying software. In most cases, you'll use existing tasks.

    Tasks themselves consist of: 
    - *Actions* : pieces of work that do something, like copy files or compile source.
    - *Inputs* : values, files and directories that the actions use or operate on.
    - *Outputs* : files and directories that the actions modify or generate.

- **Plugins** allow you to introduce new concepts into a build beyond tasks, files and 
dependency configurations. For example, most language plugins add the concept of source 
sets to a build. Plugins provide a means of reusing logic and configurations across multiple 
projects. With plugins, you can write a task once and use it in multiple builds. Or you can 
store common configurations, like logging, dependencies and version management, in one place.
    - Plugins allow code reusability and the setting of sensible defaults. Think of them as modules.

- **Build Phases** 
Gradle evaluates and executes build scripts in three build phases of the Build Lifecycle:

-	**Initialization** Sets up the environment for the build and determine which projects will take part in it.
-	**Configuration** Constructs and configures the task graph for the build. Determines which tasks need to run and in which order, based on the task the user wants to run.
-	**Execution** Runs the tasks selected at the end of the configuration phase.


___

#### [Source Sets](https://docs.gradle.org/current/userguide/building_java_projects.html#sec:java_source_sets)
Gradle uses the concept of source sets. Source sets are used to describe how files and 
resource are grouped by type, such as application code, test code, etc. Each group has 
its own dependencies, classpaths and more. Therefore specifying sources sets, help effectively
divide code by type. For example, in a java application we have `src.main.test` and `src.main.java`.
These are source sets, not because of the file structure, but because when we run a test task 
Gradle looks at `src.main.test` and the dependencies prefixed with `test` in the `build.gradle`
file, to build and run. Furthermore, the code is outputted to a `build.test` folder. The files, in 
`src.main.java` and dependencies are not considered if not used in the tests.

This default behaviour can be overriden by using `sourceSets` method on the Project object.
The `sourceSets` property emulates a directory structure, here we are placing a `src` directory, 
inside `main.java` and a `test` directory inside `test.java`.
```Kotlin
//build.gradle
sourceSets{
    main{
        java{
            setSrcDirs(listOf("src"))
            }
       }
    test{
        java{
            setSrcDirs(listOf("test"))
            }
        }
}
```
    
#### Dependencies
Specifying dependencies requires three pieces of information:
1. Which dependency you need - the name and version.
2. What it's needed for: compilation or running. 
    - Compilation: Classpath added to`javac`.
    - Running: Classpath added to`java`.
3. Where to look for it.

- To specify which dependency you need, use the `dependencies` block.
- To specify what it is needed for, choose the adequate configuration:
    - `compileOnly`: Only compilation.
    - `implementation`: Both compilation and runtime.
    - `runtimeOnly` : Only runtime. 
    - `testCompileOnly` : Compile only for tests.
    - `testImplemetation` : Both compilation and runtime for tests.
    - `testRuntimeOnly` : Only runtime for tests.
- To specify where to look for it, use the `repositories` block.

*Why do we have test and non test configurations?* Gradle uses convention-over configuration 
approach to building JVM-based projects it borrows several conventions from Apache Maven. This means that
it looks for tests under `src.main.test` and production code at `src.main.<language>`. Therefore, when 
we tell Gradle to run tests it compiles the code and uses the dependencies for tests. The same applies 
for production code.

```Kotlin
repositories{
    mavenCentral()
}
dependencies{
    implementation("org.hibernate:hibernate-core:3.6.7.Final")
}
```
#### Targeting a specific Java version
By default Gradle will compile the Java code to the language level of the JVM running Gradle.
If you need to target a specific version, you can do so several ways.
- `toolchain`  : This is the ***preferred*** way to do so as a toolchain uniformly handles
compilation, execution and Javadocs generation, and can by configured on the project level (`build.gradle`).
- `release` : Available from Java 10 onwards, it makes sure compialtion is done with 
the configured language level and against the JDK APIs from Java version.
- `sourceCompatibility` and `targetComatibility` : Not advised, used historically to configure Java version 
during compilation.
```Kotlin
// Using Toolchain
java{
    toolchain{
        languageVersion.set(JavaLanguageVersion.of(17))
        }
    }
// Using release
tasks.compileJava{
    options.release.set(7)
}
// Using *Compatibility
/*
These option can be set per `JavaCompile` task, or on the `java` extension for all compile task,
using properties with the same names.
*/
```
___

### TLDR of the above with Kotlin.
Here is a brief summary and a practical one for what we have seen above. We are going 
to create a Gradle project from scratch.

- Use the `gradle init` command in the terminal to start. 

```Kotlin
Select type of project to generate:
  1: basic
  2: application
  3: library
  4: Gradle plugin
Enter selection (default: basic) [1..4] 1

Select implementation language:
  1: C++
  2: Groovy
  3: Java
  4: Kotlin
  5: Scala
  6: Swift
Enter selection (default: Java) [1..6] 4

Select build script DSL:
  1: Groovy
  2: Kotlin
Enter selection (default: Groovy) [1..2] 2

Project name (default: demo):
Source package (default: demo):


BUILD SUCCESSFUL
2 actionable tasks: 2 executed
```

After this, you will be presented with a bare bones scaffold of the app, you will just 
see gradle stuff, no more no less.

````
├── gradle 
│   └── wrapper
│       ├── gradle-wrapper.jar
│       └── gradle-wrapper.properties
├── gradlew 
├── gradlew.bat 
├── settings.gradle.kts 
````

Now time to configure everything. In the settings.gradle we specify the name of the project.
```Kotlin
#setting.gradle.kts
rootProject.name = "gradle"
```

Now time to set up `build.gradle.kts`, remember, ***we have to tell gradle which plugins to use 
and where to download them from***. In this case gradle knows nothing about what we are 
building, `build.gradle` is empty. 
```Kotlin
/*
 * This file was generated by the Gradle 'init' task.
 *
 * This is a general purpose Gradle build.
 * Learn more about Gradle by exploring our samples at https://docs.gradle.org/8.1.1/samples
 */
```

Therefore we have to tell gradle we are building a Kotlin application, we do this by using
the **Kotlin plugin**.
- Remember, plugins are like modules for your configuration / gradle. They come with 
certain defaults for specific things.
In this case the Kotlin plugin comes with Kotlin basics such as compilation and testing, also
it specifies things such as the sourceSets (where the files are found).
```Kotlin
plugins{
    // Using Kotlin plugin for JVM and the specifying the Kotlin version
   id("org.jetbrains.Kotlin.jvm") version "1.8.20"
   // Comes with tasks to run application
   application
}

repositories{
    //Where to fetch plugins
   mavenCentral()
}
```
It is important you specify the repositories, else Gradle has no clue where to pull the dependencies
from. We specify the Kotlin plugin which takes care of the Kotlin stuff, and the ***application plugin***,
which tells Gradle "this is an application", and allows us build a CLI application.

- Remember plugins not also expose things within our `build.gradle`, for example application
exposes the application property which we use to specify out main class.

For the sake of learning, we talked about ***sourceSets***, so create a folder wherever, for example in the root
directory.
```powershell
New-Item .\<root>\example -Directory 
New-Item .\<root>\example\demo.kt -File -Value "fun main(){println("Hello from main")}"
```
Now put code in there, put a whatever file in there and introduce a main method.

- Kotlin and Gradle do not care how the file is called, ideally it is called `main.kt` or something
by the traditional style. Similarly Kotlin and Gradle do not care how the files and folders are called.
However, ideally they would *like* for the directory of the main method be called `src.main.kotlin`: there is 
where Gradle searches for. But you can alter the defaults with explicitly defining ***sourceSets***. 

Now as, mentioned above, Gradle has no idea how to run our peculiar configuration. We need to tell Gradle
two things:
1. What is our programs sourceSet.
2. What is the class that contains the main method.

> One thing to remember, Kotlin under the hood wraps files into classes if they do not contain one, 
> named `<file>Kt`. For example a file named `file.kt` would have a class named `FileKt`.

As mentioned in sourceSets, Gradle will always look for the main method in a specific folder stucture.
By using sourceSets we simulate that folder stucture and add out "out of place" folders within the 
expected structure.

```kotlin
// Simulated folder structure: main.kotlin.dir
kotlin{
   sourceSets{
      main{
         kotlin{
            setSrcDirs(listOf("example"))
         }
      }
   }
}

// Telling kotlin the main class is named DemoKt
application{
   mainClass.set("DemoKt")
}
```

And now run the command `.\gradlew run` and you should get the beautifull:
``` 
> Task :run
Hello from main

BUILD SUCCESSFUL in 1s
2 actionable tasks: 2 executed
```

Tinker around, remove things and see how it breaks, build it without specifying the sourceSets, remove the application class.

___
