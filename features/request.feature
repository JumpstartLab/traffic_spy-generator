Feature: Requests
  As a traffic spy customer
  I am able to able to register with the service
  And submit request data to have it aggregated

  Background:
    Given that a Traffic Spy server is running at 'http://127.0.0.1:9393'
    Given the user agents across all requests:
      | Weight | User Agents                                                                                                                                                                |
      | 4      | Mozilla/5.0 (Windows NT 6.1; WOW64; rv:7.0.1) Gecko/20100101 Firefox/7.0.12011-10-16 20:23:00                                                                              |
      | 3      | Mozilla/5.0 (Linux; U; Android 2.3.3; en-au; GT-I9100 Build/GINGERBREAD) AppleWebKit/533.1 (KHTML, like Gecko) Version/4.0 Mobile Safari/533.12011-10-16 20:22:55          |
      | 4      | Mozilla/4.0 (compatible; MSIE 7.0; Windows NT 5.1; InfoPath.2; .NET CLR 2.0.50727; .NET CLR 3.0.04506.648; .NET CLR 3.5.21022; .NET CLR 1.1.4322)2011-10-16 20:22:33       |
      | 3      | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_7_2) AppleWebKit/535.1 (KHTML, like Gecko) Chrome/14.0.835.202 Safari/535.12011-10-16 20:21:13                                   |
      | 4      | Mozilla/5.0 (compatible; MSIE 9.0; Windows NT 6.1; WOW64; Trident/5.0)2011-10-16 20:21:07                                                                                  |
      | 3      | Mozilla/5.0 (Linux; U; Android 4.0.3; ko-kr; LG-L160L Build/IML74K) AppleWebkit/534.30 (KHTML, like Gecko) Version/4.0 Mobile Safari/534.30                                |
      | 6      | Mozilla/5.0 (BlackBerry; U; BlackBerry 9900; en) AppleWebKit/534.11+ (KHTML, like Gecko) Version/7.1.0.346 Mobile Safari/534.11+                                           |
      | 6      | Mozilla/5.0 (Macintosh; Intel Mac OS X 10_8_2) AppleWebKit/537.22 (KHTML, like Gecko) Chrome/25.0.1364.152 Safari/537.22                                                   |
      | 2      | Mozilla/5.0 (iPhone; U; CPU iPhone OS 4_0 like Mac OS X; en-us) AppleWebKit/532.9 (KHTML, like Gecko) Version/4.0.5 Mobile/8A293 Safari/6531.22.7                          |
      | 3      | Mozilla/5.0 (iPad; U; CPU OS 3_2 like Mac OS X; en-us) AppleWebKit/531.21.10 (KHTML, like Gecko) Version/4.0.4 Mobile/7B334b Safari/531.21.102011-10-16 20:23:50           |
      | 6      | Opera/9.80 (Windows NT 6.0) Presto/2.12.388 Version/12.14                                                                                                                  |
      | 6      | Mozilla/5.0 (Windows; U; MSIE 9.0; WIndows NT 9.0; en-US))                                                                                                                 |
      | 6      | Mozilla/5.0 (compatible; MSIE 10.6; Windows NT 6.1; Trident/5.0; InfoPath.2; SLCC1; .NET CLR 3.0.4506.2152; .NET CLR 3.5.30729; .NET CLR 2.0.50727) 3gpp-gba UNTRUSTED/1.0 |
    And the resolutions across all requests:
      | Weight | Resolutions |
      | 1      | 800 x 600   |
      | 9      | 1024 x 768  |
      | 25     | 1366 x 768  |
      | 11     | 1920 x 1080 |
      | 10     | 1280 x 1024 |
      | 7      | 1440 x 900  |
      | 8      | 1280 x 800  |
      | 6      | 1680 x 1050 |
      | 5      | 1680 x 900  |
      | 1      | 2560 x 1440 |

  Scenario: Registration
    Given that the 'gSchool' source is defined with root url 'http://jumpstartlab.com'
    And a campaign, named 'Sign Up', composed with events: 'SignUpA, SignUpB, SignUpC'
    And a campaign, named 'Gallery Challenge', composed with events: 'galleryBtnA, galleryBtnB'
    When I submit 1000 requests:
      | URL                | VERB  | Response Time | Event       | Weight |
      | /                  | GET   | 2000..4500    |             | 1000   |
      | /articles          | GET   | 3000..4500    |             | 900    |
      | /articles/1        | GET   | 1000..3000    |             | 75     |
      | /articles/2        | GET   | 1000..2500    |             | 20     |
      | /articles/8        | GET   | 1000..2500    |             | 55     |
      | /articles/10       | GET   | 1000..2000    |             | 10     |
      | /galleries         | GET   | 4000..9500    | galleryBtnB | 100    |
      | /galleries         | GET   | 4000..9500    | galleryBtnA | 300    |
      | /galleries/17      | GET   | 4000..5500    |             | 80     |
      | /galleries/1       | GET   | 4000..5500    |             | 20     |
      | /galleries/2       | GET   | 4000..5500    |             | 25     |
      | /about             | GET   |  500..1000    |             | 300    |
      | /contact           | GET   |  500..1000    |             | 50     |
      | /tags              | GET   | 3000..6500    |             | 100    |
      | /tags/toy-soldiers | GET   | 3000..5500    |             | 100    |
      | /tags/game_shows   | GET   | 3000..5500    |             | 100    |
      | /users             | GET   | 2000..9000    |             | 600    |
      | /users/settings    | GET   | 2000..5500    |             | 200    |
      | /signup            | GET   | 1000..3500    | SignUpA     | 800    |
      | /signup            | POST  | 1000..1500    | SignUpB     | 400    |
      | /signup            | PUT   | 1000..1500    | SignUpC     | 200    |
      | /signout           | POST  | 1000..1500    |             | 500    |
      | /unsubscribe       | POST  | 1000..4500    | Unsubscribe | 200    |
    Then the results should be correctly represented
