# Terraform-API-Gateway

You want to have an API that will generate a random cat image? Well who doesn't. Using this repository you can have achieve your goal. Using Terraform you will send cat images that are stored in directory called `cats` to a S3 bucket with random name. 

API Gateway will then use Lambda function to get an random image from your bucket and then display it to you.

But your API is a private one - that means only those who know an API key will be able to see some cool cats. That means you will need to add a specific header to your /GET requests:

```
x-api-key: api-key-value
```

The URI for your cats is:
```
/prod/image
```

Example:

![Example](https://imgur.com/gMbvz5K)

So to deploy your API run these comamnds:
```
terraform init
terraform apply
```


