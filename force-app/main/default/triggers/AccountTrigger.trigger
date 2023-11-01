trigger AccountTrigger on Account (before insert, before update, after insert) {
    AccountTriggerHandler handler = new AccountTriggerHandler();
    
    if (Trigger.isBefore) {
        if (Trigger.isInsert || Trigger.isUpdate) {
            handler.onBeforeInsertUpdate(Trigger.new);
        }
    }
    if (Trigger.isAfter) {
        if (Trigger.isInsert ) {
            handler.onAfterInsert(Trigger.new);
        }
    }
}