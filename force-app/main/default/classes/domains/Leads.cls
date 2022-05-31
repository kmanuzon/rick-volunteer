/**
 * Domain class for Lead standard object.
 *
 * @group Domains
 */
public inherited sharing class Leads
{
    private List<Lead> records { get; private set; }

    public Leads(List<Lead> records)
    {
        this.records = records.clone();
    }

    /**
     * Create a new instance of this class.
     *
     * @return  `Leads`
     */
    public static Leads newInstance(List<Lead> records)
    {
        return new Leads(records);
    }

    /**
     * Collect website values.
     *
     * @return  `Set<String>` Set of websites
     */
    public Set<String> getWebsites()
    {
        Set<String> values = new Set<String>();

        for (Lead record : getRecords())
        {
            values.add(record.Website);
        }

        return values;
    }

    /**
     * Return all records in this domain.
     *
     * @return  `List<Lead>`
     */
    public List<Lead> getRecords()
    {
        return records;
    }
}
