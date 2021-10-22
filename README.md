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
    - [ ] Streams:
      - Kafka
      - Apache Storm 
      - *Spark*

    - [ ] Scheduler
      - Airflow
    - [ ] Pipes
      - NiFi

**_Feedback on further relevant skills welcome!_**

---
## Good to have certifications
- [x] Certified Cloud practitioner : CLF-C01
- [x] Certified Solutions Architect Associate : SAA-C02

### TODO :
- [ ] Linux Professional Institute Certification : LPIC-1
- [ ] Certified Data Analytics : DAS-C01
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
3. [Databases](#databases)
4. [Bash](#bash)
5. [LinuxOS](#linuxos)
6. [Cloud Patform](#cloud_platform)
7. [Containerisation](#containerisation)

**__Please let me know if any links become outdated.__**

<br><br>
[Python](#contents)
---

* [Automate the Boring Stuff with Python](https://automatetheboringstuff.com/): A good read for those who want a hands on approach. The [book](https://nostarch.com/automatestuff) contents are available for free on the website, as well as a [Udemy course](https://www.udemy.com/automate/?couponCode=FOR_LIKE_10_BUCKS).

* [AWS-data-wrangling](https://github.com/awslabs/aws-data-wrangler/tree/main/tutorials): A tutorial repository with many __ipython notebooks__ examples of how to process data with __python__ on __AWS services__, mostly using pandas and AWS wrangler.

* [CS109 Data Science](http://cs109.github.io/2015/): A comprehensive course from Harvard's School of Engineering and Applied Sciences. It uses Python to crunch the data.

* [DataCamp Community Tutorials](https://www.datacamp.com/community/tutorials): Tutorials, some of which are user-created, on Python, SQL, Git, R & statistics, etc ...

* [Data Processing with Python](http://opentechschool.github.io/python-data-intro/) A website that provides the foundations of data science, backed by a GitHub repository: [Introduction to Programming with Python](http://opentechschool.github.io/python-beginners/). It uses Jupyter Notebooks to load data, analyze and visualize data.

* [Pandas Tutorial](https://bitbucket.org/hrojas/learn-pandas): It uses free available _Jupyter Notebooks_  to show the fundamentals of python _Pandas_ .

* [Python Tutorial](https://pythonspot.com/): A very complete python programming tutorial. It includes how to process data, work with databases, with front-end python platforms like __Django__ (and __Flask__), and building interfaces with both __pyQT__ and __Tkinter__; as well as the use of __regEx__ and graphic libraries like __Matplotlib__.

* [Python Course](https://www.python-course.eu/python3_course.php): Comprehensive and free tutorial, reaching up to advanced OOP, passing through, _Numerical Python_, to inlcude _Machine Learning_ and _Tkinter_.

* [PyEnv Tutorial](https://github.com/pyenv/pyenv): An alternative to Conda, this tutorial works on yet another way to safely create __virtual environments__ (directories where to isolate a recipie of python binaries and required libraries for a task) managed by __pip__ on Windows or MacOS.

* [StatsModels Tutorial](https://github.com/jseabold/tutorial): This is repository of _Jupyter Notebooks_ dealing with the [StatsModels](https://www.statsmodels.org/stable/index.html) module, for those interested on statistics with Python.

* [SciPy Lecture Notes](http://www.scipy-lectures.org/): A brief (1-2 hours per module) introduction to the tools and techniques of Python's [SciPy](https://www.scipy.org/) module.

<br><br>
[R](#contents)
---
**Note**: R is a programming language used for numeric/statistical computing, graphics and data analysis. Unlike python, R's libraries are oriented toward performing specific statistical techniques, thus it is not a general-purpose language, but one excellent for numerical computing and visualising statistics. Part of the tasks of a Data Engineer depend on not just which infrastructure to choose, and how to architect it, but also on knowing how to make data ready for processing.

* [Advanced R](http://adv-r.had.co.nz/) Yet another website based on a book. It introduces the more advanced features of the R language, e.g. style, exception handling, functional programming, R's C interface, etc ...

* [DataCamp Community Tutorials](https://www.datacamp.com/community/tutorials): Tutorials, some of which are user-created, on Python, SQL, Git, R & statistics, etc ...

* [Data Science Specialization](https://www.coursera.org/specializations/jhu-data-science): A comprehensive, challenging, 10-part course from Johns Hopkins University & Coursera. Covers R, the data science workflow, stats, and some machine learning.

* [Introduction to R](https://www.datacamp.com/courses/free-introduction-to-r) A DataCamp introduction to R basics.

* [Quick-R](https://www.statmethods.net/): A website dedicated to helping individuals with some background in statistics transition to R.

* [R for Data Science](http://r4ds.had.co.nz/) An R introduction to data science and the very well impremented data "tidy" approach in R. This training is structured into the 5 natural steps taken when working with data: Explore, Wrangle, Program, Model, and Communicate. It does good use of the R libraries _dplyr_, _tidyr_, and _ggplot2_. Also available as a book.

* [R Tutorial](http://www.cyclismo.org/tutorial/R/): A basic intro to R and stats from the University of Georgia, Department of Mathematics.

* [Swirl](https://swirlstats.com/): Swirl is actually an R package that allows you to learn R interactively in the R console. Some prefer using RStudio for writing R code.

* [The Analytics Edge](https://www.edx.org/course/analytics-edge-mitx-15-071x-3): Semester-long course from MIT & edX. Covers stats/DS using real-world examples.


<br><br>
[Databases](#contents)
---

* [Database minicourses from Stanford](https://lagunita.stanford.edu/courses/DB/2014/SelfPaced/about): A thorough introduction to databases, mostly relational databases, SQL, and database design.

* [OTS SQL Tutorial](http://opentechschool.github.io/sql-tutorial/): A language-agnostic guide to SQL for beginners.

* [PSQL Cheatsheet](https://gist.github.com/Kartones/dd3ff5ec5ea238d4c546): A repository containing a concise collection of commands for __PSQL__, which is a command-line program, one of the available front-end tools for administering the relational database __postgreSQL__. Its shell-like approach offer the possibility for writing scripts, and thus the automation of tasks.



<br><br>
[Bash](#contents)
---
* [Bash Guide](https://tldp.org/LDP/Bash-Beginners-Guide/html/index.html): This a complete simple naked html guide to Bash scripting for beginners.

* [Bash Handbook](https://github.com/denysdovhan/bash-handbook): Git repository where to find a complete guide for Bash scripting. If you are using a JavaScript runtime environment like Node.js, this handy book is available to download as a npm package.

* 

<br><br>
[LinuxOS](#contents)
---

* [LinuxBash](https://www.cnsr.dev/index_files/Classes/DataStructuresLab/Content/01-02-LinuxBash.html): A course at the Missouri State university and a wealth of interesting links explaining Linux, from the file system, commands, shells and scripting.

* [LPIC-2](https://github.com/lpic2book/src/): Git repository where to find exam materials in preparation for the Linux Professional Institute Certification, intermediate level for __LinuxOS__ sysAdmins.



<br><br>
[Cloud Platform](#contents)
---

* [AWS Templates](https://github.com/awslabs/aws-cloudformation-templates/tree/master/aws): Repository of __json__ and __yaml__ templates to start your IaC deployment of AWS cloud ressources.

* [Application Architecture](https://martinfowler.com/tags/application%20architecture.html): Very interesting blog on topics and ideas that may improve your knowledge of architectural solutions for developing applications.

<br><br>
[Containerisation](#contents)
---

* [Dockerised Geodata Server](https://github.com/Overv/openstreetmap-tile-server): This git repository comes with a complete set of instructions, including dockerfiles, to set up serve tiled cartography using a __postgreSQL__ database and an __Apache webserver__.

* [OSRM](https://github.com/Project-OSRM/osrm-backend): Repository of a High performance routing engine written in C++14 designed to run on OpenStreetMap data, which can be used to build uppon a routing service container.