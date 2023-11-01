global class ScheduleInativarContasBatch implements Schedulable {
    global void execute(SchedulableContext SC) {
        InativarContasBatch b = new InativarContasBatch();
        Database.executeBatch(b);
    }

    global static String scheduleIt() {
        String cronExp = '0 0 0,6,12,18 ? * MON-FRI';
        String jobName = 'InativarContasBatch';
        ScheduleInativarContasBatch s = new ScheduleInativarContasBatch();
        return System.schedule(jobName, cronExp, s);
    }
}