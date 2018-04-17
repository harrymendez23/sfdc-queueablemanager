# SFDC Queueable Manager
Queueable orchestration in Salesforce.com platform.

## Overview
The Queueable interface in Salesforce's platform allows code execution in an asynchronous fashion while providing a number of advantages over future calls. But, like everything in Salesforce, comes with a number of limitations. One challenge is the orchestration of calls, specially from other async contextes like batch apex and queueable itself, which in some instances result in "too many queueable jobs added to the queue:" exception. The problem is that the number of queueable jobs you can add depends on the context, where in syncrounous context you can add up 50 jobs, in async context you can only call one additional job.

 
