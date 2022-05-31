/**
 * Selector class for Account standard object.
 *
 * @group Selectors
 */
public inherited sharing class AccountsSelector
{
    /**
     * Create a new instance of this class.
     *
     * @return  `AccountsSelector`
     */
    public static AccountsSelector newInstance()
    {
        return new AccountsSelector();
    }

    /**
     * Query records by website field.
     *
     * @param websites Filter by website.
     * @return  `List<Account>` Queried records.
     */
    public List<Account> selectByWebsite(Set<String> websites)
    {
        return [
            SELECT
                Id,
                Website
            FROM Account
            WHERE Website IN :websites
        ];
    }
}
