/**
* @author Harry Mendez <harry.mendez@verizon.com>
* @date 2018-03-01
*
* @group GenericHelpers
*
* @description 
* Purpose: Helper to orchestrate queueable jobs execution by managing limits check.
* Requirement: Req-10929 - Trigger Refactoring
* Test Class: QueueableManager_Test
* Modification History:
*		 Harry Mendez - 03/01/2018: Created.
*/
public class QueueableManager {
	@TestVisible
    private static Map<String, QueueableJob> queue;
    
    @TestVisible
    private static Boolean IsQueueableAvailable = Limits.getQueueableJobs() < Limits.getLimitQueueableJobs()? true: false;
    
    @TestVisible
    private static void setIsQueueableAvailable(Boolean b) {
    	if(!Test.isRunningTest()) return;
    		
    	IsQueueableAvailable = b;
    }
    
    static {
        queue = new Map<String, QueueableJob>();
    }
    
    /*
    * @description Method for adding Queueable jobs to QueueableManager's queue.
    * @param qName Unique job key.
    * @param q Queueable instance for execution.
    * @return 
    * @example
    * QueueableManager.enqueueJob('updateRecords', new Queueable(data));
    */
    public static void enqueueJob(String qName, Queueable q) {
    	if(!queue.containsKey(qName)) {
    		QueueableJob qj = new QueueableJob(q);
    		queue.put(qName, qj);
    	}
    }
    
    /*
    * @description Method for adding Queueable jobs to QueueableManager's queue and releasing the queue right after.
    * @param qName Unique job key.
    * @param q Queueable instance for execution.
    * @return Queueable job Id
    * @example
    * QueueableManager.enqueueAndExecute('updateRecords', new Queueable(data));
    */
    public static ID enqueueAndExecute(String qName, Queueable q) {
    	enqueueJob(qName, q);
    	executeAll();
    	return queue.get(qName).jobId;
    }
    
    /*
    * @description Executes all Queueable instances in queue. Takes care of enqueueing versus execution based on available resources.
    * @return 
    * @example
    * QueueableManager.executeAll();
    */
    public static void executeAll() {
        system.debug('executeAll queueables: ' + queue);
        system.debug('Limits.getLimitQueueableJobs(): ' + Limits.getLimitQueueableJobs());
        if(!queue.isEmpty()) {
            for(QueueableJob q : queue.values()) {
                //Enqueue or execute only if jobs has not been executed in current thread
                //if(Limits.getQueueableJobs() < Limits.getLimitQueueableJobs() && !q.executed) {
                if(IsQueueableAvailable && !q.executed) {
                    system.debug('enqueuing job');
                    //q.setExecuted();
                	//system.enqueueJob(q.qJob);
                	q.JobPath = JobPath.ENQUEUED;
                	q.setExecuted(system.enqueueJob(q.qJob));
                }//If there's no queueable capacity, execute job syncronously
                //else if(Limits.getQueueableJobs() == Limits.getLimitQueueableJobs() && !q.executed) {
                else if(!IsQueueableAvailable && !q.executed) {
                    system.debug('executing job : ' + q);
                    //q.setExecuted();
                    q.qJob.execute(new QueueableManager.QueueableContext()); //execute syncronously
                    q.JobPath = JobPath.EXECUTED;
                    q.setExecuted(null);
                }
                else  {
                	q.JobPath = JobPath.SKIPPED;
                }
            }
        }
    }
    @TestVisible
    private enum JobPath { ENQUEUED, EXECUTED, SKIPPED }
    /**
	* @author Harry Mendez <harry.mendez@verizon.com>
	* @date 2018-03-01
	*
	* @group GenericHelpers
	*
	* @description 
	* Purpose: Helper for tracking of Queueable instances execution.
	*/
	@TestVisible
    private class QueueableJob {
    	@TestVisible
    	protected JobPath JobPath;
    	@TestVisible
		protected Queueable qJob;
		@TestVisible
        protected Boolean executed;
        @TestVisible
        protected ID jobId;
        
        public QueueableJob(Queueable qj) {
            this.qJob = qj;
            this.executed = false;
        }
        
        public void setExecuted(ID jId) {
            this.executed = true;
            this.jobId = jId;
        }
    }
    
    /**
	* @author Harry Mendez <harry.mendez@verizon.com>
	* @date 2018-03-01
	*
	* @group GenericHelpers
	*
	* @description 
	* Purpose: Helper to provide System.QueueableContext behavior.
	*/
	@TestVisible
    private class QueueableContext implements System.QueueableContext {
    	@TestVisible
    	public ID getJobId() { return null; }
    }
}