/**
 * Domain class for Account standard object.
 *
 * @group Domains
 */
public inherited sharing class Accounts
{
    private List<Account> records { get; private set; }

    public Accounts(List<Account> records)
    {
        this.records = records.clone();
    }

    /**
     * Create a new instance of this class.
     *
     * @return  `Accounts`
     */
    public static Accounts newInstance(List<Account> records)
    {
        return new Accounts(records);
    }

    /**
     * Generate key value pair of account id as value and website as key.
     *
     * @return  `Map<String, Id>` Key value pair of account id by website.
     */
    public Map<String, Id> getAccoutIdByWebsite()
    {
        Map<String, Id> accountIdByWebsite = new Map<String, Id>();

        for (Account record : getRecords())
        {
            // do not process if website field is blank
            if (String.isBlank(record.Website)) continue;

            // make sure this is lower case because map key is case sensitive
            String websiteLowerCase = record.Website.toLowerCase();

            accountIdByWebsite.put(websiteLowerCase, record.Id);
        }

        return accountIdByWebsite;
    }

    /**
     * Return all records in this domain.
     *
     * @return  `List<Account>`
     */
    public List<Account> getRecords()
    {
        return records;
    }
}
