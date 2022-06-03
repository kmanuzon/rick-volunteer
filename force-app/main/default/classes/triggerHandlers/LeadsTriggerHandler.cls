/**
 * Trigger handler class for Lead standard object.
 *
 * @group Trigger Handlers
 */
public without sharing class LeadsTriggerHandler
{
    /**
     * Create a new instance of this class.
     *
     * @return  `LeadsTriggerHandler`
     */
    public static LeadsTriggerHandler newInstance()
    {
        return new LeadsTriggerHandler();
    }

    /**
     * Handle after insert event.
     */
    public void onAfterInsert()
    {
        createAccounts(Trigger.new);
        createContacts(Trigger.new);
    }

    /**
     * Create account record for each lead.
     *
     * @param records
     */
    private void createAccounts(List<Lead> records)
    {
        Map<String, Id> accoutIdByAccountWebsite = getAccountIdByAccountWebsite(records);

        List<Account> newAccountRecords = new List<Account>();

        for (Lead record : records)
        {
            // do not process if website field is blank
            if (String.isBlank(record.Website)) continue;

            // make sure this is lower case because map key is case sensitive
            String websiteLowerCase = record.Website.toLowerCase();

            // skip if Lead.Website already matches an account.Website
            if (accoutIdByAccountWebsite.containsKey(websiteLowerCase)) continue;

            // @TODO add lead to account mapped fields here
            newAccountRecords.add(new Account(
                Name = record.Company,
                Website = record.Website
            ));
        }

        insert newAccountRecords;
    }

    /**
     * Create contact record for each lead.
     *
     * @param records
     */
    private void createContacts(List<Lead> records)
    {
        Map<String, Id> accoutIdByAccountWebsite = getAccountIdByAccountWebsite(records);

        List<Contact> newContactRecords = new List<Contact>();

        for (Lead record : records)
        {
            // do not process if website field is blank
            if (String.isBlank(record.Website)) continue;

            // make sure this is lower case because map key is case sensitive
            String websiteLowerCase = record.Website.toLowerCase();

            Id accountId = accoutIdByAccountWebsite.get(websiteLowerCase);

            // @TODO add lead to contact mapped fields here
            newContactRecords.add(new Contact(
                AccountId = accountId,
                FirstName = record.FirstName,
                LastName = record.LastName,
                Email = record.Email
            ));
        }

        insert newContactRecords;
    }

    /**
     * Generate key value pair of account id as value and account website as
     * key.
     *
     * @param leadRecords Lead records.
     * @return  `Map<String, Id>` Account id by account website map.
     */
    private Map<String, Id> getAccountIdByAccountWebsite(List<Lead> leadRecords)
    {
        Set<String> websites = Leads.newInstance(leadRecords).getWebsites();

        List<Account> accountRecords = AccountsSelector.newInstance().selectByWebsite(websites);

        return Accounts.newInstance(accountRecords).getIdByWebsite();
    }
}
