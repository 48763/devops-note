# Groovy
Groovy is a Java-syntax-compatible object-oriented programming language for the Java platform.

## Basic Steps

### node
Allocates an executor on a node and runs further code in the context of a workspace on that slave.

```groovy
// Process express
node {
	// Process express
}
```

*Default workspace path - `JENKINS_HOME/worksapce/PROJECT_NAME/`, so you can only operate in this directory.*

#### Operators
The following operators are supported, in descending order of precedence:

- `()`
Parentheses — Used to explicitly define the associativity of an expression

- `!a`
NOT — negation; The result of expression must not be true

- `a && b`
AND — Both of the expressions a and b must be true

- `a || b`
OR — Either of the expressions a or b may be true

- `a -> b`
"implies" operator — Equivalent to !a || b. 

- `a <-> b`
"if and only if" operator — Equivalent to a && b || !a && !b 

#### def 
Defined variables.

```groovy
def repo = env.JOB_BASE_NAME
def repoMeta = vars.repoMeta(repo)
```

#### env
Environment variables are accessible from Groovy code as env.VARNAME or simply as VARNAME.

```groovy
env.BASH_CACHE = env.WORKSPACE + '/bash-cache'
```

<a href="http://localhost:8080/pipeline-syntax/globals#env
">Global Variable Reference</a>

#### if-else

```groovy
def a = 1;
def b = 2;
if(a > b) {
	echo "Big a";
} else {
	echo "Big b";
}
```

### sh 
Runs a Bourne shell script, typically on a Unix node. Multiple lines are accepted.

```groovy
def str1 = "This is a global variables."
sh '#!/bin/bash' + """
	echo ${str1} Don't using mistake.
""" + '''
	str1="This is a Local variables."
	echo $str1 Don't using mistake.
'''
```

### stage 
Create a custom stage.
```groovy
node {

	stage('Checkout') {
		// You can to do anything process related to this stage.
	}
}
```

### dir
Change current directory.

```groovy
def repo = env.JOB_BASE_NAME 
dir('repo/'+ repo) {
	stage('move') {
		// You can to do anything process related to this stage.
	}
}
```

### retry
Retry the block (up to N times) if any exception happens during its body execution. 

```groovy
retry(3) {
    sh 'curl localhost || exit 1'
}
```

### sshagent
SSH Agent.

```groovy
sshagent(['github-48763-bot']) {
	git -C repo pull --rebase origin "$BRANCH_BASE"
}
```
[Add credentials](../manage-jenkins.md#credentials)

### withDockerRegistry
Specifies a registry URL, plus an optional credentials ID to connect to it.

```groovy
withDockerRegistry([credentialsId: "harbor-admin",
    url:"https://lab.yukifans.com"]) {
}
```

[Add credentials](../manage-jenkins.md#credentials)

## General SCM

### checkout
This is a special step that allows to run checkouts using any configuration options offered by any Pipeline-compatible SCM plugin.

```groovy
checkout([
	$class: 'GitSCM',
	userRemoteConfigs: [[
		name: 'origin',
		url: repoMeta['url'],
		credentialsId: 'github-48763-bot',
	]],
	branches: [[name: '*/' + repoMeta['branch-push']]],
	extensions: [
		[
			$class: 'CleanCheckout',
		],
		[
			$class: 'RelativeTargetDirectory',
			relativeTargetDir: 'repo',
		],
	],
	doGenerateSubmoduleConfigurations: false,
	submoduleCfg: [],
])
```

### properties

```groovy
properties([
	buildDiscarder(logRotator(numToKeepStr: '10')),
	disableConcurrentBuilds(),
	pipelineTriggers([
		cron('H H * * *'),
	]),
])
```