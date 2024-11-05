# (DPP) Digital Product Passport

The Move contract **dpp.move** defines a notarization system to track key events throughout the lifecycle of a product. It includes distinct roles (e.g., Manufacturer, Distributor, Retailer) and uses events to log operations such as creation, distribution, sale, maintenance, and recycling. Permissions are managed through capabilities (`Capabilities`), assigned by authorized entities via specific contract functions.

To facilitate contract management, the **Makefile** includes various commands that automate tasks such as creating addresses, publishing the contract, and granting capabilities.

### Permission Hierarchy: Admin and DID Issuer

The contract uses a **hierarchical permission system** to manage access and capabilities. Here’s how it works:

- **AdminCapability**: This is the highest level of authority within the system. An entity with `AdminCapability` can grant various other capabilities, including `VCIssuerCapability` and other `AdminCapability` roles to additional addresses. This role is intended for trusted administrators who manage access and ensure the correct distribution of permissions within the system.

- **VCIssuerCapability**: A role granted by an admin, allowing an entity to authorize users with specific roles to write events on the blockchain. This capability enables the creation of `TraceCapability` for roles like Manufacturer, Distributor, Retailer, etc. The VC Issuer cannot grant `AdminCapability` to others, ensuring that only designated administrators control the highest level of access.

By structuring permissions this way, the system maintains a clear separation of roles: Admins handle governance and permission distribution, while DID Issuers focus on assigning operational roles for traceability and event management.

### Makefile Usage Instructions

Install [sui cli](https://docs.sui.io/guides/developer/getting-started/sui-install)

1. **List Addresses**:
   ```bash
   make addresses-list
   ```
   This command displays the list of addresses used by the Sui client. It is useful for viewing available accounts and verifying addresses before assigning capabilities.

2. **Create a New Address**:
   ```bash
   make new-address
   ```
   Generates a new address with an `ed25519` public key, useful for creating new accounts to which specific capabilities can be assigned.

3. **List Objects**:
   ```bash
   make objects-list
   ```
   Shows all objects associated with the current address, including any `TraceCapability`, `VCIssuerCapability`, or `AdminCapability`.

4. **Request Funds (Faucet)**:
   ```bash
   make faucet
   ```
   Requests funds from the faucet for testing. This ensures the account has the necessary budget for on-chain operations.

5. **Build the Contract**:
   ```bash
   make build-contract
   ```
   Compiles the Move contract located in the `./dpp` folder, checking for any errors. This compilation step is essential before publishing or upgrading the contract.

6. **Upgrade the Contract**:
   ```bash
   make upgrade-contract
   ```
   Upgrades an existing contract version. This is useful when making changes or improvements to the code and wanting to apply them on-chain.

7. **Publish the Contract**:
   ```bash
   make publish-contract
   ```
   Publishes the `dpp` contract to the blockchain, making it available for operations. This command is used when deploying the contract for the first time or after significant updates.

8. **Grant Admin Capability**:
   ```bash
   make grant-admin-cap
   ```
   Assigns `AdminCapability` to a specific address, authorizing it to grant other capabilities. This is a critical operation reserved for administrators, as they are responsible for defining the access structure.

9. **Grant VC Issuer Capability**:
   ```bash
   make grant-vc-issuer-cap
   ```
   Grants an address the `VCIssuerCapability`, allowing it to authorize users to create DIDs and publish events. Only admins can grant this capability.

10. **Grant Trace Capability**:
    ```bash
    make grant-trace-cap
    ```
    This command assigns a specific `TraceCapability` to an address with a defined role (such as `manufacturer`, `distributor`, etc.). Roles determine which operations the address can perform on the contract.

11. **Record an Event**:
    ```bash
    make trace_event
    ```
    Logs an event in the product lifecycle. This command requires that the address holds the necessary `TraceCapability`. Each event is recorded on-chain with a timestamp, product ID, proof, and other relevant information.

12. **Convert Keys**:
    ```bash
    make convert-key
    ```
    Uses the `sui keytool` to convert an existing private key into keystore format. Useful when managing external keys or importing keys from other formats.

### Usage Example
To record a distribution event, first assign the `TraceCapability` to an address with the `distributor` role. Then, use `trace_event` to log the distribution operation.