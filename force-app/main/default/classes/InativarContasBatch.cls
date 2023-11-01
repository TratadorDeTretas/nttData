public class InativarContasBatch implements Database.Batchable<SObject> {

    public InativarContasBatch() {
    }

    public Iterable<SObject> start(Database.BatchableContext BC) {
        Map<Id, Task> taskMap = new Map<Id, Task>([SELECT WhatId FROM Task WHERE What.Type = 'Account' AND CreatedDate >= LAST_N_DAYS:90]);
        Map<Id, Opportunity> oppMap = new Map<Id, Opportunity>([SELECT AccountId FROM Opportunity WHERE Account.Inactive__c = false AND ((CreatedDate >= LAST_N_DAYS:120 AND isWon = true) OR IsClosed = false)]);
        Set<Id> accountIdsToExclude = new Set<Id>();
        for(Task t : taskMap.values()) {
            accountIdsToExclude.add(t.WhatId);
        }
        for(Opportunity o : oppMap.values()) {
            accountIdsToExclude.add(o.AccountId);
        }
        return [SELECT Id, Inactive__c FROM Account WHERE Id NOT IN :accountIdsToExclude AND Inactive__c = false limit 250];
    }

    public void execute(Database.BatchableContext BC, List<Account> scope) {
        if(scope.isEmpty()) {
            return;
        }

        for (Account a : scope) {
            a.Inactive__c = true;
        }
    
        update scope;
    }

    public void finish(Database.BatchableContext BC) {
    }
}