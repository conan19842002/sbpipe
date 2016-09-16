# Developer manual

Mailing list: sb_pipe AT googlegroups.com

Forum: [https://groups.google.com/forum/#!forum/sb_pipe](https://groups.google.com/forum/#!forum/sb_pipe)


## Introduction
This guide is meant for developers and contains guidelines for developing 
this project. 


## Development model
This project follows the Feature-Branching model. Briefly, there are two
main branches: `master` and `develop`. The former contains the history 
of stable releases, the latter contains the history of development. The 
`master` branch contains checkout points for production hotfixes 
or merge points for release-x.x.x branches. The `develop` branch is used 
for feature-bugfix integration and checkout point in development. Nobody 
should directly develop in here. The `develop` branch is versionless 
(just call it *-dev*).


### Conventions
To manage the project in a more consistent way, here is a list of conventions 
to follow:

- Each new feature is developed in a separate branch forked from *develop*. 
This new branch is called *featureNUMBER*, where *NUMBER* is the number of 
the GitHub Issue discussing that feature. The first line of each commit message for 
this branch should contain the string *Issue #NUMBER* at the beginning. Doing so, the 
commit is automatically recorded by the Issue Tracking System for that specific 
Issue. Note that the sharp (#) symbol is required.
- The same for each new bugfix, but in this case the branch name is called 
bugfixNUMBER.
- The same for each new hotfix, but in this case the branch name is called 
hotfixNUMBER and is forked from *master*.


### Work flow
The procedure for checking out a new feature from the `develop` branch 
is: 
```
$ git checkout -b feature10 develop
```
This creates the `feature10` branch off `develop`. This feature10 is discussed 
in *Issue #10* in GitHub.
When you are ready to commit your work, run:
```
$ git commit -am "Issue #10, summary of the changes. Detailed 
description of the changes, if any."
$ git push origin feature10       # sometimes and at the end.
```

As of June 2016, the branches `master` and `develop` are protected and a
status check using Travis-CI must be performed before merging or pushing
into these branches. This automatically forces a merge without 
fast-forward. 
In order to merge **any** new feature, bugfix or simple edits into 
`master` or `develop`, a developer **must** checkout a new branch and, 
once committed and pushed, **merge** it to `master` or `develop` using a
`pull request`. To merge `feature10` to `develop`, the pull request output 
will look like this in GitHub Pull Requests:
```
base:develop  compare:feature10   Able to merge. These branches can be 
automatically merged.

```
A small discussion about feature10 should also be included to allow 
other users to understand the feature.

Finally delete the branch: 
```
$ git branch -d feature10      # delete the branch feature10 (locally)
```


### New releases
When the `develop` branch includes all the desired feature for a 
release, it is time to checkout this 
branch in a new one called `release-x.x.x`. It is at this stage that a 
version is established. Only bugfixes or hotfixes are applied to this 
branch. When this testing/correction phase is completed, the `master` 
branch will merge with the `release-x.x.x` branch, using the commands 
above.
To record the release add a tag:
```
git tag -a v1.3 -m "PROGRAM_NAME v1.3"
```
To transfer the tag to the remote server:
```
git push origin v1.3   # Note: it goes in a separate 'branch'
```
To see all the releases:
```
git show
```


## Package structure
This section presents the structure of the SB pipe package. The root of the project contains general management scripts for cleaning the package (clean_pacakge.py), installing Python and R dependencies (install_pydeps.py and install_rdeps.r), and installing SB pipe (setup.py). Additionally, the logging configuration file (logging_config.ini) is also at this level.

In order to automatically compile and run the test suite, Travis-CI is used and configured accordingly (.travis.yml).

The project is structured as follows: 
```
sb_pipe:
  | - docs
  | - sb_pipe
        | - pipelines
        | - utils
  | - tests
```
These folders will be discussed in the next sections. In SB pipe, Python is the project main language. Instead, R is essentially used for computing statistics within the *data analysis tasks* (see section configuration file in User manual) and for generating plots. This choice allows users to run these scripts independently of SB pipe if needed using an R environment like Rstudio. This can be convenient 
if further data analysis are needed or plots need to be annotated or edited.


### docs
The folder *docs/* contains the documentation for this project. The user and developer manuals are contained inside the subfolder *source*. In order to generate the complete documentation for SB pipe, the following packages must be installed: 

- python-sphinx
- pandoc
- texlive-fonts-recommended
- texlive-latex-extra

By default the documentation is generated in html and LaTeX/PDF. Instruction for generating or cleaning SB pipe documentation are provided below.

To generate the source code documentation:
```
$ ./gen_doc.sh
```

To clean the documentation:
```
$ ./clean_doc.sh
```

If new folders containing new Python modules are added to the project, it is necessary to update the sys.path in *source/conf.py* to include these additional paths. 


### sb_pipe
This folder contains the main script for running SB pipe (run_sb_pipe.py). 
This script is an interface for the project.

#### pipelines
The folder */sb_pipe/pipelines/* contains the following pipelines within folders:

- *create_project*: creates a new project
- *simulate*: simulates a model deterministically or stochastically
using Copasi (this must be configured first), generate plots and report;
- *single_param_scan*: runs Copasi (this must be 
configured first), generate plots and report;
- *double_param_scan*: runs Copasi (this must be 
configured first), generate plots and report;
- *param_estim*: generate a fits sequence using Copasi 
(this must be configured first), generate tables for statistics.

These pipelines are invoked directly via the script *sb_pipe/run_sb_pipe.py*. Each pipeline extends the class *Pipeline*, 
which represents a generic and abstract pipeline. Each pipeline must implement the following methods of *Pipeline*: 
```
def run(self, config_file)
def read_configuration(self, lines)
```

The method *run()* contains the procedure to execute for a specific configuration file. The method *read_configuration()* is needed 
for reading the options required by the pipeline to execute. The class *Pipeline* contains already implements the INI parser and returns 
each pipeline the configuration file as a list of lines.


#### Utils
The folder *sb_pipe/utils/* contains the following structure:

- *python*: a collection of python utils.
- *R*: a collection of R utils (plots and statistics).


### Tests
The folder *tests/* contains the script *run_tests.py* to run a test 
suite. It should be used for testing the correct installation of SB pipe
dependencies as well as reference for configuring a project before 
running any pipeline. 
Projects inside the folder tests/ have the SB pipe project structure:

- *Data*: (e.g. training / testing data sets for the model);
- *Model*: (e.g. Copasi models, datasets directly used by Copasi models);
- *Working_Folder*: (e.g. pipelines configurations and parameter 
estimation results, time course, parameter scan, etc).

Examples of configuration files (*.conf) can be found in 
${SB_PIPE}/tests/insulin_receptor/Working_Folder/.

Travis-CI runs SB pipe tests using `nosetests`. Please see .travis.yml 
for detail.






## Miscellaneous of useful commands
### Git
**Startup**
```
$ git clone https://YOURUSERNAME@server/YOURUSERNAME/sb_pipe.git   
# to clone the master
$ git checkout -b develop origin/develop                           
# to get the develop branch
$ for b in `git branch -r | grep -v -- '->'`; do git branch 
--track ${b##origin/} $b; done     # to get all the other branches
$ git fetch --all    # to update all the branches with remote
```

**Update**
```
$ git pull [--rebase] origin BRANCH  # ONLY use --rebase for private 
branches. Never use it for shared branches otherwise it breaks the 
history. --rebase moves your commits ahead. I think for shared 
branches, you should use `git fetch && git merge --no-ff`. 
**[FOR NOW, DON'T USE REBASE BEFORE AGREED]**.
```

**File system**
```
$ git rm [--cache] filename 
$ git add filename
```

**Information**
```
$ git status 
$ git log [--stat]
$ git branch       # list the branches
```

**Maintenance**
```
$ git fsck      # check errors
$ git gc        # clean up
```

**Rename a branch locally and remotely**
```
git branch -m old_branch new_branch         # Rename branch locally    
git push origin :old_branch                 # Delete the old branch    
git push --set-upstream origin new_branch   # Push the new branch, set 
local branch to track the new remote
```

**Reset**
```
git reset --hard HEAD    # to undo all the local uncommitted changes
```

**Syncing a fork (assuming upstreams are set)**
```
git fetch upstream
git checkout develop
git merge upstream/develop
```