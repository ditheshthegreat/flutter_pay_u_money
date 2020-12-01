# flutter_pay_u_money

A Flutter plugin for payumoney gateway in the mobile platform. Supports Android only.



# Contributing
**Currently supported for only Android Platform. Not for iOS right now.
If you want to make it more better or want to add more platforms support then feel free to contribute.**


#### Initiate Payment

```    
var _payuData = PayUData(
  ///your merchant ID
  merchantId: '',

  ///your merchant key
  merchantKey: '',

  ///your salt
  salt: '',

  ///product name
  productName: 'blah blah',

  /// custom transaction id
  txnId: 'some1234thing',

  ///optional you can add an hash from server side or you can generate from here
  ///the hash sequence should be => key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5||||||salt;
  //hash: '',

  ///this udfs[User Defined Field] is optional you can add up to 10 if you want extra field to pass
  // udf: ['udf1', 'udf2', 'udf3', 'udf4', 'udf5', 'udf6', 'udf7', 'udf8', 'udf9', 'udf10'],
  amount: '125',
  firstName: 'tester',
  email: 'test@gmail.com',
  phone: '9876543210',
);
```
#### For Sandbox
    
```
 var _flutterPayUMoney = FlutterPayUMoney.test(payUData: _payuData);
```

#### For Live
   
```
 var _flutterPayUMoney = FlutterPayUMoney.production(payUData: _payuData);
```
   
#### To Generate Hash Natively

```
 await _flutterPayUMoney.hashIt();
```
#### Start Payment

```
    await _flutterPayUMoney.pay(
      paymentResponse: (statusCode, data) {
        print('$statusCode :: $data');
        setState(() {
          _resultData = '$statusCode :: $data';
        });
      },
    );
```
#### Payment Response Status Code

Code | Status |
--- | --- | 
200 | Success |
400 | Failure |
401 | Validation Error |
402 | User Payment Cancelled  |

- [See example for more details](https://pub.dev/packages/flutter_pay_u_money/example)


#### Server Code
To generate hash from server side

```php
    <?php 
    header('Content-Type: application/json');
    header('Access-Control-Allow-Origin: *');
    
function preparePayuPayment($params)
{        
    $SS_URL = (isset($params['SS_URL']))? $params['SS_URL'] : '';
    $FF_URL = (isset($params['FF_URL']))? $params['FF_URL'] : '';
    $params['key'] = 'KSXB9Z3J';    
    
    $hashSequence = 'key|txnid|amount|productinfo|firstname|email|udf1|udf2|udf3|udf4|udf5|udf6|udf7|udf8|udf9|udf10';
    
    $formError = 0;
    $txnid = '';
    if(empty($params['txnid']))
    {
      $txnid = substr(hash('sha256', mt_rand() . microtime()), 0, 20);
    }
    else
    {
      $txnid = $params['txnid'];
    }    
    
    $params['txnid'] = $txnid;
    $hash = '';
    
    if(empty($params['hash']) && sizeof($params) > 0)
    {
        if(empty($params['txnid']) || empty($params['amount']) || empty($params['firstname']) || empty($params['email']) || empty($params['phone']) || empty($params['productinfo']))
        {
            $formError = 1;
        }
        else
        {
            $hashVarsSeq = explode('|', $hashSequence);
            $hash_string = '';    
            foreach($hashVarsSeq as $hash_var)
            {
                  $hash_string .= isset($params[$hash_var]) ? $params[$hash_var] : '';
                  $hash_string .= '|';
              }
            $hash_string .= $params['SALT_KEY'];
            $hash = strtolower(hash('sha512', $hash_string));
        }
    }
    else if(!empty($params['hash']))
    {
        $hash = $params['hash'];
    }
    
    $params['hash'] = $hash;
    return array('status'=>$formError, 'params'=>$params);
}
if($_SERVER['REQUEST_METHOD'] == 'POST') {
  $allParmas = array(
       'key' => 'KSXB9Z3J',
       'txnid' => $_POST['txnid'],
       'amount' => $_POST['amount'],
       'SALT_KEY' => 'AwuZ5FVG4c',
       'productinfo' => $_POST['productinfo'],
       'firstname' => $_POST['firstname'],
       'email' => $_POST['email'],
       'phone'=> $_POST['phone'],
       'udf1' => '',
       'udf2' => '',
       'udf3' => '',
       'udf4' => '',
       'udf5' => '',
       'udf6' => '',
       'udf7' => '',
       'udf8' => '',
       'udf9' => '',
       'udf10' => ''
     );
     $returnData = preparePayuPayment($allParmas);
     echo json_encode($returnData);
}else {

  echo json_encode(array(
    'error' => 'data not passed',

  ));
}
     ?> 
```

### IMPORTANT
1. You have to setup a server for generating Hash for starting payments then you have to call the function for starting payment. OK.
2. All used payment details are fake but you can use maerchant id and maerchant key for testing because these are test keys provided by PayuMoney

#### Issues
If you are having any issues relating to this plugin then you can create a issue at this github repo.

