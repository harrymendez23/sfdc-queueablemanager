@isTest
public class QueueableManager_Test {
	
	@isTest
	public static void shouldEnqueueJob() {
		//enqueue test job
		Test.startTest();
		testJob tj = new testJob('test job first execution');
		QueueableManager.enqueueJob('testJob1', tj);
		QueueableManager.executeAll();
		
		Test.stopTest();
		//Job should've been executed
		QueueableManager.QueueableJob qJob = QueueableManager.queue.get('testJob1');
		system.assertEquals(QueueableManager.JobPath.ENQUEUED, qJob.JobPath);
		system.assertEquals(true, qJob.executed);
		
		//Same job wil not execute more than once
		QueueableManager.enqueueJob('testJob1', tj);
		QueueableManager.executeAll();
		system.assertEquals(true, qJob.executed);
		system.assertEquals(QueueableManager.JobPath.SKIPPED, qJob.JobPath);
	}
	
	@isTest
	public static void shouldEnqueueAndExecuteJob() {
		//enqueue test job
		Test.startTest();
		testJob tj = new testJob('test job first execution');
		QueueableManager.enqueueAndExecute('testJob1', tj);
		Test.stopTest();
		//Job should've been executed
		QueueableManager.QueueableJob qJob = QueueableManager.queue.get('testJob1');
		system.assertEquals(QueueableManager.JobPath.ENQUEUED, qJob.JobPath);
		system.assertEquals(true, qJob.executed);
	}
	
	@isTest
	public static void shouldExecuteSynchronously() {
		//enqueue test job
		Test.startTest();
		testJob tj = new testJob('test job first execution');
		QueueableManager.setIsQueueableAvailable(false);
		QueueableManager.enqueueAndExecute('testJob1', tj);
		Test.stopTest()
		;
		//Job should've been executed
		QueueableManager.QueueableJob qJob = QueueableManager.queue.get('testJob1');
		system.assertEquals(QueueableManager.JobPath.EXECUTED, qJob.JobPath);
		system.assertEquals(true, qJob.executed);
	}
	
	public class testJob implements Queueable {
		private String internalOut;
		public testJob(String o) {
			internalOut = o;
		}
		
		public void execute(QueueableContext context) {
			system.debug(internalOut);
		}
	}
}