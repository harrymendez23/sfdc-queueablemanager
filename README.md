# SFDC Queueable Manager
Queueable orchestration in Salesforce.com platform.

## Overview
The Queueable interface in Salesforce's platform allows code execution in an asynchronous fashion while providing a number of advantages over future calls. But, like everything in Salesforce, comes with a number of limitations. One challenge is the orchestration of calls, specially from other async contextes like batch apex and queueable itself, which in some instances result in "too many queueable jobs added to the queue:" exception. The problem is that the number of queueable jobs you can add depends on the context, where in syncrounous context you can add up 50 jobs, in async context you can only call one additional job.

 
Queueable Manager comes to the rescue; It tracks queueu availability on all contextes, making sure your code is always execute without issues. While queue space is available, your jobs will be enqueued as usual, then executed synchrously when resources are consumed. It also keeps track of which jobs have have already been executed during the transaction, helping avoid enqueuing the same job more than once.
