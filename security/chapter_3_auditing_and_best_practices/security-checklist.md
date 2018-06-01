# Security Checklist

This is list of best practices of how your company should implement secure deployments.


## Enable Access Control and Enforce Authentication

- Specify proper authentication mechanism between client and MongoDB server.
- If running on clustered deployments, consider to enable internal authentication.


## Configure Role-Based Access Control

- Since authentication will caused localhost exception, consider to created administrator user at first.
- Create appropriate roles for each user. If built-in roles do not satisfy user privileges, then consider to create user defined roles. Use most efficient definition to crate user defined roles.


## Encrypt Communication

Consider to use full `TLS/SSL` for all incoming and outgoing connections.


## Encrypt and Protect Data

- Consider using WiredTiger as storage engine, then enabled `encryption at rest`.
- Consider using Key Management Interoperability Protocol (KMIP) to manage and rotate security keys.
- Ensure `700` permission on `database directory`.


## Limit Network Exposure

- Configure firewalls to control access to MongoDB systems.
- Ensure secured tunnel to MongoDB by using `VPN\VPC`.
- Use `bind_ip` to prevent back door access.


## Run MongoDB with a Dedicated User

- MongoDB should not run as the root user, but **should run as `mongod` user**.


## Run MongoDB with Secure Configuration Options

- Disable the HTTP status interface.
- Disable the REST API.
- Disable server-side scripting.


## Request a Security Technical Guide (STIG)

- The Security Technical Implementation Guide (STIG) contains security guidelines for deployments within the United States Department of Defense. MongoDB Inc. provides its STIG, upon request, for situations where it is required. Please [request a copy](https://www.mongodb.com/lp/contact/stig-requests) for more information.


## Consider Security Standards Compliance

For applications requiring HIPAA or PCI-DSS compliance, please refer to the [MongoDB Security Reference Architecture](https://www.mongodb.com/collateral/mongodb-security-architecture) to learn more about how you can use the key security capabilities to build compliant application infrastructure.