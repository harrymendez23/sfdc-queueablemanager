# SFDC Queueable Manager
Queueable orchestration in Salesforce.com platform.

## Overview
The Queueable interface in Salesforce's platform allows code execution in an asynchronous fashion while providing a number of advantages over future calls. But, like everything in Salesforce, comes with a number of limitations. One challenge is the orchestration of calls, specially from other async contextes like batch apex and queueable itself, which in some instances result in "too many queueable jobs added to the queue:" exception. The problem is that the number of queueable jobs you can add depends on the context, where in syncrounous context you can add up 50 jobs, in async context you can only call one additional job.

 
Queueable Manager comes to the rescue; It tracks queueu availability on all contextes, making sure your code is always execute without issues. While queue space is available, your jobs will be enqueued as usual, then executed synchrously when resources are consumed. It also keeps track of which jobs have have already been executed during the transaction, helping avoid enqueuing the same job more than once.

## Usage
Use QueueableManager in place of system.enqueueJob. Following example enqueues your job in the system queue:

```Java
SomeQueueable q = new SomeQueueable();
q.someValue = 1;
QueueableManager.enqueueAndExecute('SomeQueueableInstance1', q);
```

Another option is to add multiple jobs to the queue and then executing all of them, for a better control of when your jobs are actually enqueued:

```Java
SomeQueueable q1 = new SomeQueueable();
q1.someValue = 1;
QueueableManager.enqueueJob('SomeQueueableInstance1', q1);
///Something else can be done here
//Then at some point during transaction add another job
SomeQueueable q2 = new SomeQueueable();
q2.someValue = 2;
QueueableManager.enqueueJob('SomeQueueableInstance2', q2);
///Something more here
//Then execute (system.enqueue) all jobs previously added to the queue
QueueableManager.executeAll();
```
