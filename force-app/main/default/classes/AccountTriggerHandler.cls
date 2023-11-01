public class AccountTriggerHandler {

    public void onBeforeInsertUpdate(List<Account> accounts) {
        validateAccountNumber(accounts);
    }

    public void onAfterInsert(List<Account> accounts) {
        createFollowup(accounts);
    }

    private void validateAccountNumber(List<Account> accounts){
        for (Account a : accounts) {
            Boolean result = a.Type__c == 'CNPJ' ? Utils.ValidaCNPJ(a.AccountNumber__c) : Utils.ValidaCPF(a.AccountNumber__c);
            if(!result){
                a.addError('Número do cliente é inválido');
            }
        }
    }

    private void createFollowup(List<Account> accounts) {
        List<Opportunity> opportunitiesToInsert = new List<Opportunity>();
        List<Task> tasksToInsert = new List<Task>();
        Map<String, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();
        for (Account a : accounts) {
            if (a.RecordTypeId == rtMap.get('Parceiro').getRecordTypeId()) {
                Opportunity opp = new Opportunity();
                opp.Name = a.Name + ' - opp Parceiro';
                opp.CloseDate = Date.today().addDays(30);
                opp.AccountId = a.Id;
                opp.StageName = 'Qualification';
                opportunitiesToInsert.add(opp);
            } else if (a.RecordTypeId == rtMap.get('ConsumidorFinal').getRecordTypeId()) {
                Task task = new Task();
                task.Subject = 'Consumidor Final';
                task.Status = 'Not Started';
                task.Priority = 'Normal';
                task.WhatId = a.Id;
                tasksToInsert.add(task);
            }
        }

        if (!opportunitiesToInsert.isEmpty()) {
            insert opportunitiesToInsert;
        }

        if (!tasksToInsert.isEmpty()) {
            insert tasksToInsert;
        }
    }
}