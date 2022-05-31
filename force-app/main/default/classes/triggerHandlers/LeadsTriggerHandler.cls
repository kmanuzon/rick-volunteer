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
     * @param leadRecords
     */
    private void createAccounts(List<Lead> leadRecords)
    {
        Leads domain = Leads.newInstance(leadRecords);

        Set<String> websites = domain.getWebsites();

        List<Account> accountRecords = AccountsSelector.newInstance().selectByWebsite(websites);

        Map<String, Id> accoutIdByWebsite = Accounts.newInstance(accountRecords).getAccoutIdByWebsite();

        List<Account> newAccountRecords = new List<Account>();

        for (Lead leadRecord : domain.getRecords())
        {
            // do not process if website field is blank
            if (String.isBlank(leadRecord.Website)) continue;

            // make sure this is lower case because map key is case sensitive
            String websiteLowerCase = leadRecord.Website.toLowerCase();

            // skip if Lead.Website already matches an account.Website
            if (accoutIdByWebsite.containsKey(websiteLowerCase)) continue;

            // @TODO add lead to account mapped fields here
            newAccountRecords.add(new Account(
                Name = leadRecord.Company,
                Website = leadRecord.Website
            ));
        }

        insert newAccountRecords;
    }

    /**
     * Create contact record for each lead.
     *
     * @param leadRecords
     */
    private void createContacts(List<Lead> leadRecords)
    {
        Leads domain = Leads.newInstance(leadRecords);

        Set<String> websites = domain.getWebsites();

        // requery account records in case createAccount has inserted new ones
        List<Account> accountRecords = AccountsSelector.newInstance().selectByWebsite(websites);

        Map<String, Id> accoutIdByWebsite = Accounts.newInstance(accountRecords).getAccoutIdByWebsite();

        List<Contact> newContactRecords = new List<Contact>();

        for (Lead leadRecord : leadRecords)
        {
            // do not process if website field is blank
            if (String.isBlank(leadRecord.Website)) continue;

            // make sure this is lower case because map key is case sensitive
            String websiteLowerCase = leadRecord.Website.toLowerCase();

            Id accountId = accoutIdByWebsite.get(websiteLowerCase);

            // @TODO add lead to contact mapped fields here
            newContactRecords.add(new Contact(
                AccountId = accountId,
                FirstName = leadRecord.FirstName,
                LastName = leadRecord.LastName,
                Email = leadRecord.Email
            ));
        }

        insert newContactRecords;
    }
}
