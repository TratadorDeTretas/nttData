@isTest
public class AccountTriggerHandlerTest {

    @isTest static void testOnBeforeInsertUpdate() {
        Map<String, Schema.RecordTypeInfo> rtMap = Schema.SObjectType.Account.getRecordTypeInfosByDeveloperName();

        Account a1 = new Account(Name = 'Test Account 1', RecordTypeId = rtMap.get('Parceiro').getRecordTypeId(), Type__c = 'CPF', AccountNumber__c = '12345678901');
        Account a2 = new Account(Name = 'Test Account 2', RecordTypeId = rtMap.get('ConsumidorFinal').getRecordTypeId(), Type__c = 'CNPJ', AccountNumber__c = '12345678901234');
        insert a1;

        try{
            insert a2;
        }catch(Exception e){
            System.assert(e.getMessage().contains('Número do cliente é inválido'), 'CNPJ sempre deveria lançar erro.');
            a2.Type__c = 'CPF';
            insert a2;
        }

        Opportunity[] opps = [SELECT Id, Name FROM Opportunity];
        System.assertEquals(a1.Name + ' - opp Parceiro', opps[0].Name, 'Expected one Opportunity to be created for account 1');

        Task[] tasks = [SELECT Id, WhatId FROM Task];
        System.assertEquals(a2.Id, tasks[0].WhatId, 'Expected one Task to be created for account 2');
    }
}