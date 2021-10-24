codeSkills
=========

Collection space for samples of skills, career path, and 3rd party available resources online. 

---
## Goals for a Role as Data Engineer:
These are the skills I intend to acquire for becoming a **Data Engineer**.
* [x] Python
* [x] SQL
* [x] Linux (SysOps)
* [x] Bash Scripting

* Platforms :
    - [x] Cloud knowledge
      -  *AWS*
      - Google Cloud Platform
      - Azure
 
     - [x] Containerisation
       - *Docker*
       - Kubernetes
* [x] DBs :
    - MongoDB
    - *PostgreSQL*
    - MySQL
    - Elastisearch
* [ ] Warehousing DBs :
    - Amazon Redshift
    - Google Bigquery
    - Apache Cassandra
* [ ] Data Pipelines :
    - [ ] Streams :
      - Kafka
      - Apache Storm 
      - *Spark*

    - [ ] Scheduler :
      - Airflow
    - [ ] Pipes :
      - NiFi

**_Feedback on further relevant skills welcome!_**

---
## Good to have certifications
- [x] Certified Cloud practitioner : CLF-C01
- [x] Certified Solutions Architect Associate : SAA-C02

### TODO :
- [ ] Linux Professional Institute Certification : LPIC-1
- [ ] Certified AWS Data Analytics : DAS-C01
- [ ] Linux Professional Institute Certification : LPIC-2
- [ ] Docker Certified Associate : DCA
- [ ] Certified Kubernetes Administrator : CKA
- [ ] Certified AWS SysOps administrator : SOA-C02
- [ ] Hashicorp Certified Terraform Associate : TA-002-P
- [ ] AWS Certified DevOps Engineer : DOP-C01

---

Collection of Training Links
---
1. [Python](#python)
2. [R](#r)
3. [SQL](#sql)
4. [Databases](#databases)
5. [Bash](#bash)
6. [LinuxOS](#linuxos)
7. [Cloud Patform](#cloud_platform)
8. [Containerisation](#containerisation)
9. [IaC](#iac)

**__Please let me know if any links become outdated.__**

<br><br>
[Python](#contents)
---

* [Automate the Boring Stuff with Python](https://automatetheboringstuff.com/): A good read for those searching a hands-on approach. This website makes freely available the contents of the homonymous [book](https://nostarch.com/automatestuff).

* [AWS-data-wrangling](https://github.com/awslabs/aws-data-wrangler/tree/main/tutorials): A tutorial repository with many __ipython notebooks__, examples of how to process data with __python__ on [__AWS services__](https://docs.aws.amazon.com/index.html), that mostly use [__pandas__](https://pandas.pydata.org/pandas-docs/stable/getting_started/index.html) and __AWS wrangler__.

* [DataCamp Community Tutorials](https://www.datacamp.com/community/tutorials): Tutorials, some of which are user-created, on Python, SQL, Git, R & statistics ...

* [Data Processing with Python](http://opentechschool.github.io/python-data-intro/) A website that provides the foundations of data science, backed by a GitHub repository: [Introduction to Programming with Python](http://opentechschool.github.io/python-beginners/). It uses [__Jupyter Notebooks__](https://jupyter.org/try) to load, analyze and visualize data.

* [iPython Cookbook](https://github.com/ipython/ipython/wiki/Cookbook%3A-Index): A gitHub repository holding a wealth of links to pages on how to use and how to integrate __iPython__.

* [Pandas Tutorial](https://bitbucket.org/hrojas/learn-pandas): It uses free available [_Jupyter Notebooks_](https://jupyter.org/try)  to show the fundamentals of python [_Pandas_](https://pandas.pydata.org/pandas-docs/stable/getting_started/index.html) .

* [Psycopg Documentation](https://www.psycopg.org/docs/): An official documentation site to the very popular __PostgreSQL__ adapter for Python. It establishes a database connection for python-written, multi-threaded applications, which means it is designed for large amounts of concurrent operations (i.e. cursors).

* [Python Tutorial](https://pythonspot.com/): A very complete python programming tutorial. It includes how to process data, work with databases, with front-end python platforms like __Django__ (and __Flask__), and building interfaces with both __pyQT__ and __Tkinter__; as well as the use of __regEx__ and graphic libraries like __Matplotlib__.

* [Python Course](https://www.python-course.eu/python3_course.php): Comprehensive and free tutorial, reaching up to advanced OOP, passing through, _Numerical Python_, to inlcude related tools like _Tkinter_. Plus a three-column wide board of events, news, and advanced topics.

* [Python Requests](https://docs.python-requests.org/en/master/): This documentation website is home to the python library __Requests__, which allows python to setup and keep alive a connection through http to the web.

* [PyEnv Tutorial](https://github.com/pyenv/pyenv): An alternative to Conda, this tutorial works on yet another way to safely create __virtual environments__ (directories where to isolate a recipie of python binaries and required libraries for a task) managed by __pip__ on Windows or MacOS.

* [Py Module Index](https://docs.python.org/3/py-modindex.html): A a page containig an alphabetical index of links to each and every python3 module.

* [StatsModels Tutorial](https://github.com/jseabold/tutorial): This is repository of _Jupyter Notebooks_ dealing with the [StatsModels](https://www.statsmodels.org/stable/index.html) module, for those interested on statistics with Python.

* [SciPy Lecture Notes](http://www.scipy-lectures.org/): A brief introduction to the tools and techniques of Python's [SciPy](https://www.scipy.org/) module.

<br><br>
[R](#contents)
---
**Note**: R is a programming language used for numeric/statistical computing, graphics and data analysis. Unlike python, R's libraries are oriented toward performing specific statistical methods, thus it is not a general-purpose language, but one excellent for numerical computing and visualising statistics. Part of the tasks of a Data Engineer depend not just on which infrastructure to choose, and how to architect it, but also on knowing how to make data ready for processing.

* [Advanced R](http://adv-r.had.co.nz/) Yet another website based on a book. It introduces the more advanced features of the R language, e.g. style, exception handling, functional programming, R's C interface, etc ...

* [DataCamp Community Tutorials](https://www.datacamp.com/community/tutorials): Tutorials, some of which are user-created, on R, and as aforementioned also Python, SQL, Git, ...

* [Data Wrangling](https://clayford.github.io/dwir): Very neat course notes from the University of Virginia, encompassing from basics, to R data structures, data manipulation, data washing and the "Tidy" approach. The corresponding R files are available at [Github](https://github.com/clayford/DataWranglingInR).

* [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r) A DataCamp introduction to R basics.

* [Quick-R](https://www.statmethods.net/): A website dedicated to users of other statistical packages (i.e. SAS, SPSS), as well as individuals with a background in statistics, who want to adopt R.

* [R for Data Science](http://r4ds.had.co.nz/) An R introduction to data science and the very well impremented data "tidy" approach in R. This training is structured into the 5 natural steps taken when working with data: Explore, Wrangle, Program, Model, and Communicate. It does good use of the R libraries _dplyr_, _tidyr_, and _ggplot2_. Also available as a book.

* [R Official Docs](https://www.rdocumentation.org/): A website from which to search and browse each and every available R package.

* [R Tutorial](http://www.cyclismo.org/tutorial/R/): A basic intro to R and stats from the University of Georgia, Department of Mathematics.

* [Swirl](https://swirlstats.com/): Swirl is actually an R package that allows you to learn R interactively in the R console (some prefer using RStudio) for writing R code.

* [The Analytics Edge](https://www.edx.org/course/analytics-edge-mitx-15-071x-3): A course from MIT & edX that can be taken for free, or with extended materials and features for 200$. It lasts for 13 weeks (10–15 hours per week), for those with a previous knowledge of statistics and programming.

<br><br>
[SQL](#contents)
---
* [SQL exercises](https://pgexercises.com/): Best Creative Commons licensed site to practice and learn __SQL__ syntax.

* [SQL Tutorials](https://www.sqltutorial.org/): A webpage structured around SQL commands and practical examples, that allow access to working with data (sorting, querying, filtering ...) and with defining database structures for database administrators or data analysts.

<br><br>
[Databases](#contents)
---

* [Database course Stanford](https://online.stanford.edu/courses/soe-ydatabases-databases): A thorough introduction to databases, as well as one dedicated to [__relational databases__](https://online.stanford.edu/courses/soe-ydatabases0005-databases-relational-databases-and-sql), SQL, and database design.

* [MongoDB Tutorial](https://docs.mongodb.com/manual/tutorial/getting-started/): Official website offering tutorials and manuals on some of the most frequently used operations on a noSQL database, as well as online [courses](https://university.mongodb.com/courses/catalog).

* [OTS SQL Tutorial](http://opentechschool.github.io/sql-tutorial/): A language-agnostic guide to SQL for beginners.

* [PostgreSQL ManPage](https://www.postgresql.org/docs/current/index.html): Official website comprising the PostgreSQL documentation for each and every release.

* [PSQL Cheatsheet](https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546): A repository containing a concise collection of commands for __PSQL__, which is a command-line interface or front-end tool for administering the relational database __postgreSQL__. Because of its shell-like approach it offers the possibility for writing scripts, and thus the automation of tasks.

<br><br>
[Bash](#contents)
---
* [Bash Guide](https://tldp.org/LDP/Bash-Beginners-Guide/html/index.html): This a complete simple naked html guide to Bash scripting for beginners.

* [Bash Handbook](https://github.com/denysdovhan/bash-handbook): Git repository where to find a complete guide for Bash scripting. If you are using a JavaScript runtime environment like Node.js, this handy book is available to download as a npm package.

<br><br>
[LinuxOS](#contents)
---

* [LinuxBash](https://www.cnsr.dev/index_files/Classes/DataStructuresLab/Content/01-02-LinuxBash.html): A course at the Missouri State university and a wealth of interesting links explaining Linux, from the file system to commands, shells and scripting.

* [Linux Essentials](https://learning.lpi.org/en/learning-materials/010-160/): This is the official LPIC learning materials for those who intend to become acquainted with basic linux commands, and LinuxOs administration from the terminal.

* [LPIC-1](https://learning.lpi.org/en/): This official site from the Linux Professional Institute includes the learning materials to prepare for their LinuxOS certification in two blocks, i.e. LPIC-1 [__Exam 101__](https://learning.lpi.org/en/learning-materials/101-500/) and LPIC-1 [__Exam 102__](https://learning.lpi.org/en/learning-materials/102-500/).

* [LPIC-2](https://github.com/lpic2book/src/): Git repository where to find exam materials in preparation for the Linux Professional Institute Certification, intermediate level for __LinuxOS__ sysAdmins.

<br><br>
[Cloud Platform](#contents)
---
* [AWS CLF CheatSheet](https://digitalcloud.training/certification-training/aws-certified-cloud-practitioner/): In-depth training notes for the AWS Practitioner (i.e. beginner) certification test.

* [AWS SAA CheatSheet](https://digitalcloud.training/certification-training/aws-solutions-architect-associate/): 
 These are in-depth training notes toward the intermediate level certification AWS Certified Solutions Architect–Associate ([__SAA-C02__](https://d1.awsstatic.com/training-and-certification/docs-sa-assoc/AWS-Certified-Solutions-Architect-Associate_Exam-Guide.pdf)) exam.
 
* [AWS SOA CheatSheet](https://digitalcloud.training/certification-training/aws-certified-sysops-administrator-associate/): These are in-depth training notes toward the intermediate level certification AWS Certified SysOps Administrator–Associate ([__SOA-C02__](https://d1.awsstatic.com/training-and-certification/docs-sysops-associate/AWS-Certified-SysOps-Administrator-Associate_Exam-Guide.pdf)) exam.

* [AWS DVA CheatSheet](https://digitalcloud.training/certification-training/aws-developer-associate/): These are in-depth training notes toward the intermediate level certification AWS Certified Developer–Associate ([__DVA-C01__](https://d1.awsstatic.com/training-and-certification/docs-dev-associate/AWS-Certified-Developer-Associate_Exam-Guide.pdf)) exam.

* [AWS SAP CheatSheet](https://digitalcloud.training/certification-training/aws-certified-solutions-architect-professional/): These are in-depth training notes toward the intermediate level certification AWS Certified Solutions Architect–Professional ([__SAP-C01__](https://digitalcloud.training/certification-training/aws-certified-solutions-architect-professional/)) exam.

* [AWS Templates](https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws): Repository of __json__ and __yaml__ templates to start your IaC deployment of AWS cloud ressources.

* [Application Architecture](https://martinfowler.com/tags/application%20architecture.html): Very interesting blog on topics and ideas that may improve your knowledge of architectural solutions for developing applications.

<br><br>
[Containerisation](#contents)
---

* [Dockerised Geodata Server](https://github.com/Overv/openstreetmap-tile-server): This git repository comes with a complete set of instructions, including dockerfiles, to serve tiled cartography using a __postgreSQL__ database and an __Apache webserver__.

* [OSRM](https://github.com/Project-OSRM/osrm-backend): Repository of a High performance routing engine written in C++14 designed to run on OpenStreetMap data, which can be used to build uppon a routing service container.

<br><br>
[IaC](#contents)
---

* [Docker Compose](https://docs.docker.com/compose/): Docker official documentation page for __Docker Compose__, a native way of orchestrating multi-container developments using Docker technology.

* [YAML](https://yaml.org/): Website providing exhaustive information on __yaml__ serialisation language specifications according to different programming frameworks.
