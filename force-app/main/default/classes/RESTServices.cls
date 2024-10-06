@RestResource(UrlMapping='/accounts/*')
global with sharing class RESTServices {
    private static final Integer maxQuerySize = 200;

    @HttpGet
    global static List<Account> doGet() {
        String searchExpr = extractQuery(RestContext.request.requestURI);
        return ((isAccountId(searchExpr)) ? searchByAccountId(searchExpr) : searchByAccountName(searchExpr));
    }

    private static List<Account> searchByAccountId(String accountId) {
        return [SELECT Id,
                       Name,
                       BillingAddress,
                       Type,
                       Industry
                  FROM Account
                 WHERE Id = :accountId
                  WITH SECURITY_ENFORCED
                 LIMIT :maxQuerySize
        ];
    }

    private static List<Account> searchByAccountName(String accountName) {
        return [SELECT Id,
                       Name,
                       BillingAddress,
                       Type,
                       Industry
                  FROM Account
                 WHERE Name LIKE :accountName
                    OR BillingCity LIKE :accountName
                    OR BILLINGState LIKE :accountName
                  WITH SECURITY_ENFORCED
              ORDER BY Name ASC
                 LIMIT :maxQuerySize
        ];
    }

    private static String extractQuery(String uri) {
        String result = '';
        String query = (uri.substring(uri.lastIndexOf('accounts/') + 9).replaceAll('\\+', ' ').replaceAll('\\&amp;', '&'));
        result = ((isAccountId(query)) ? query : ('%' + query + '%'));
        return result;
    }

    private static Boolean isAccountId(String s1) {
        Boolean result = false;
        String s2 = String.escapeSingleQuotes(s1).replaceAll('\\+', ' ');

        if (s2.length() == 15 || s2.length() == 18) {
            if (s2.substring(0,3) == '001') {
                if (!s2.contains(' ')) {
                    if (Pattern.matches('^[a-zA-Z0-9]*$', s2)) {
                        result = true;
                    }
                }
            }
        }

        return result;
    }
}