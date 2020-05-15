# pipeline
A continuous delivery (CD) pipeline is an automated expression of your process for getting software from version control right through to your users and customers. 

A pipeline consists of a chain of processing elements (processes, threads, coroutines, functions, etc.).

Flows with one-directional tree and directed acyclic graph topologies behave similarly to (linear) pipelines – the lack of cycles makes them simple – and thus may be loosely referred to as "pipelines".

Jenkins Pipeline is a suite of plugins which supports implementing and integrating continuous delivery pipelines into Jenkins.

## Create a pipeline.
1. Click new Job.
2. Enter an item name.
3. Choice option of *pipeline*.
4. Final click 'OK'.

## Setting a pipeline.
1. Scroll to down, will have found pipeline setting block.
2. Choice *pipeline script from SCM* in definition option.(You also copy and past pipeline script to script block.)
3. Choice *Git* in SCM option.
4. Enter your repository URL of stored pipeline script.(e.g. https://github.com/48763/jenkins-test-script.git)
5. Choice your Credentials, if you clone git using SSH.
6. Use default master branch, if you only one branch.
7. Enter script path and file name.（Start from root. e.g. Jenkinsfile/main.groovy)
8. Save your setting.

## Read more about pipeline 
- [Start write script use Groovy.](./groovy/)
