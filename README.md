# (DPP) Digital Product Passport

The Move contract **dpp.move** defines a notarization system to track key events throughout the lifecycle of a product. It includes distinct roles (e.g., Manufacturer, Distributor, Retailer) and uses events to log operations such as creation, distribution, sale, maintenance, and recycling. Permissions are managed through capabilities, assigned by authorized entities via specific contract functions.

To facilitate contract management, the **Makefile** includes various commands that automate tasks such as creating addresses, publishing the contract, and granting capabilities.

## Permission Hierarchy: Admin and VC Issuer

The contract uses a **hierarchical permission system** to manage access and capabilities. Here’s how it works:

- **AdminCapability**: This is the highest level of authority within the system. An entity with `AdminCapability` can grant various other capabilities, including `VCIssuerCapability` and other `AdminCapability` roles to additional addresses. This role is intended for trusted administrators who manage access and ensure the correct distribution of permissions within the system.

- **VCIssuerCapability**: A role granted by an admin, allowing an entity to authorize users with specific roles to write events on the blockchain. This capability enables the creation of `TraceCapability` for roles like Manufacturer, Distributor, Retailer, etc. The VC Issuer cannot grant `AdminCapability` to others, ensuring that only designated administrators control the highest level of access.

By structuring permissions this way, the system maintains a clear separation of roles: Admins handle governance and permission distribution, while VC Issuers focus on assigning operational roles for traceability and event management.


## Makefile Usage Instructions

Install [Sui CLI](https://docs.sui.io/guides/developer/getting-started/sui-install)

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

6. **Test the Contract**:
   ```bash
   make test-contract
   ```
   Runs a series of automated tests to verify the functionality of the dpp.move contract.

7. **Publish the Contract**:
   ```bash
   make publish-contract
   ```
   Publishes the `dpp` contract to the blockchain, making it available for operations. This command is used when deploying the contract for the first time or after significant updates.

8.  **Grant Admin Capability**:
   ```bash
   make grant-admin-cap
   ```
   Assigns `AdminCapability` to a specific address, authorizing it to grant other capabilities. This is a critical operation reserved for administrators, as they are responsible for defining the access structure.

9.  **Grant VC Issuer Capability**:
   ```bash
   make grant-vc-issuer-cap
   ```
   Grants an address the `VCIssuerCapability`, allowing it to create VC. Only admins can grant this capability.

10. **Grant Trace Capability**:
    ```bash
    make grant-trace-cap
    ```
    This command assigns a specific `TraceCapability` to an address with a defined role (such as `manufacturer`, `distributor`, etc.).

11. **Record an Event**:
    ```bash
    make trace_event
    ```
    Logs an event in the product lifecycle. This command requires that the address holds the necessary `TraceCapability`. Each event is recorded on-chain with a timestamp, product ID, proof, and other relevant information.


## Usage Example
To record a `distribution event`, follow these steps:

1. **Assign `VCIssuerCapability`**: Use the `make grant-vc-issuer-cap` command to grant an address the role of VC Issuer. This role authorizes the address to grant other operational capabilities, such as `TraceCapability`.
   
2. **Assign `TraceCapability` for the distributor role**: Use the `make grant-trace-cap` command to assign an address the `TraceCapability` with the specific role of `distributor`. This enables the address to record events related to distribution.

3. **Record the distribution event**: Once the necessary capabilities have been assigned, use `make trace_event` to log the distribution event on the blockchain. Each event is recorded with a timestamp, product ID, proof, and other relevant information.

**Note**: Remember to update the addresses in the `Makefile` to reflect those used in your environment.

---

## Retrieve Data
To view and verify recorded events, you can use the Sui testnet GraphQL IDE.

### Accessing Data
Visit the [Online Testnet IDE](https://sui-testnet.mystenlabs.com/graphql) to query events recorded on the blockchain.

### Query Example
The following GraphQL query retrieves specific events related to a particular event type and sender:

```graphql
{
  events(
    filter: {
      eventType: "0x0d087311f002d3204e364b1c5e3159ff1f0c975edb8df367d78e28d1716a9c67::dpp::TraceableEvent",
      sender: "0x7e8ec7b99b938d2f2b3238524438d911ce9a6825f43ab98160cbb5bc94382045"
    }
  ) {
    nodes {
      sender {
        address
      }
      transactionBlock {
        digest
      }
      timestamp
      contents {
        json
      }
    }
  }
}
```

### Example Result
Here is an example of the JSON response format you may receive:

```json
{
  "data": {
    "events": {
      "nodes": [
        {
          "sender": {
            "address": "0x7e8ec7b99b938d2f2b3238524438d911ce9a6825f43ab98160cbb5bc94382045"
          },
          "transactionBlock": {
            "digest": "6jEWCTzmmCE3tqiZD8gdvkEPJGyAeYj5z5TNtYxLetnt"
          },
          "timestamp": "2024-11-04T11:18:20.870Z",
          "contents": {
            "json": {
              "signer_addr": "0x7e8ec7b99b938d2f2b3238524438d911ce9a6825f43ab98160cbb5bc94382045",
              "product_id": "product123",
              "operation": {
                "Manufacturer": {}
              },
              "uris": [
                "https://example.com/uri1",
                "https://example.com/uri2"
              ],
              "proofs": [
                "proof1",
                "proof2"
              ],
              "optional_data": "optional data",
              "previous_tx": "previous transaction hash",
              "timestamp": "1730663875132"
            }
          }
        }
      ]
    }
  }
}
```