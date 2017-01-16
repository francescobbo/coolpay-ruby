# Coolpay API Bindings for Ruby

Since I didn't know whether I had to write a web application or a simple console
utility, I started to write some "common" code, the interface to the API.

In the open-source style of Ruby, I packaged the code as a *gem*.

## Usage

First of all, initialize the client with appropriate credentials, or an access
token, if you have one:

    coolpay = Coolpay::Client.new('username', 'secret')
    # OR
    coolpay = Coolpay::Client.new
    coolpay.token = '123-1434563-3333132'

### Create a recipient

    coolpay.create_recipient('Albert Einstein')

### Lookup a recipient

    coolpay.find_recipient('Albert Einstein')
    # [{"name"=>"Albert Einstein", "id"=>"b23ed8dc-0c0f-49e4-a846-dafe519aaafb"}]

### Create a payment

    coolpay.create_payment(100, 'GBP', 'b23ed8dc-0c0f-49e4-a846-dafe519aaafb');

### List all payments

    coolpay.list_payments
    # [{"status"=>"processing", "recipient_id"=>"b23ed8dc-0c0f-49e4-a846-dafe519aaafb", "id"=>"8f253d62-e7f8-4ff8-8c38-58294bccb5a2", "currency"=>"GBP", "amount"=>"100"}, ...]

