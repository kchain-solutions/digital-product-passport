
module dpp::dpp{
    use sui::event;
    use sui::clock;
    use std::string::{utf8, String}; 

    const EINVALID_ROLE: u64 = 1;

    public enum Role has store, copy, drop {
        Manufacturer,
        Distributor,
        Retailer,
        Maintenance,
        Refurbisher,
        Recycler,
        Auditor,
    }

    //Role Capabilities
    public struct AdminCapability has key {
        id: UID
    }

    public struct DidsIssuerCapability has key {
        id: UID
    }

    public struct TraceCapability has key, store {
        id: UID,
        role: Role
    }

    // Event
    public struct TraceableEvent has drop, store, copy {
        signer_addr: address,
        product_id: String,
        operation: Role,
        description: String,
        uri: String,
        optional_data: String,
        previous_tx: String,
        timestamp: u64
    } 

    fun init(ctx: &mut TxContext){
        let sender_addr = tx_context::sender(ctx);
        transfer::transfer(AdminCapability {
            id: object::new(ctx)
        }, sender_addr);
    } 

    public entry fun grant_admin_capability(_: &AdminCapability, recipient: address, ctx: &mut TxContext){
        transfer::transfer(AdminCapability {
            id: object::new(ctx)
        }, recipient);
    }

    public entry fun grant_dids_issuer_capability(_: &AdminCapability, recipient: address, ctx: &mut TxContext){
        transfer::transfer(DidsIssuerCapability {
            id: object::new(ctx)
        }, recipient);
    }

    public entry fun grant_product_transaction_capability(
        _: &DidsIssuerCapability, 
        recipient: address, 
        role_str: String, 
        ctx: &mut TxContext
    ) {
        if (role_str == utf8(b"manufacturer")) {
            transfer::public_transfer(TraceCapability {
                id: object::new(ctx),
                role: Role::Manufacturer
            }, recipient);
        } else if (role_str == utf8(b"distributor")) {
            transfer::public_transfer(TraceCapability {
                id: object::new(ctx),
                role: Role::Distributor
            }, recipient);
        } else if (role_str == utf8(b"retailer")) {
            transfer::public_transfer(TraceCapability {
                id: object::new(ctx),
                role: Role::Retailer
            }, recipient);
        } else if (role_str == utf8(b"maintenance")) {
            transfer::public_transfer(TraceCapability {
                id: object::new(ctx),
                role: Role::Maintenance
            }, recipient);
        } else if (role_str == utf8(b"refurbisher")) {
            transfer::public_transfer(TraceCapability {
                id: object::new(ctx),
                role: Role::Refurbisher
            }, recipient);
        } else if (role_str == utf8(b"recycler")) {
            transfer::public_transfer(TraceCapability {
                id: object::new(ctx),
                role: Role::Recycler
            }, recipient);
        } else if (role_str == utf8(b"auditor")) {
            transfer::public_transfer(TraceCapability {
                id: object::new(ctx),
                role: Role::Auditor
            }, recipient);
        } else {
            abort EINVALID_ROLE 
        }
    }

       public entry fun create_product_transaction_event(
        audit_trail_cap: &TraceCapability,
        product_id: String,
        description: String,
        uri: String,
        optional_data: String,
        previous_tx: String,
        ctx: &mut TxContext
    ) {
        event::emit<TraceableEvent>( TraceableEvent {
            signer_addr: tx_context::sender(ctx),
            product_id,
            operation: audit_trail_cap.role,
            description,
            uri,
            optional_data,
            previous_tx,
            timestamp: ctx.epoch_timestamp_ms()
        });
    }
}

