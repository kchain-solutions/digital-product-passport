
module dpp::dpp{
    use sui::event;
    use std::string::{utf8, String}; 

    const EINVALID_ROLE: u64 = 1;

    //Capabilities
    public struct AdminCapability has key {
        id: UID
    }

    public struct VCIssuerCapability has key {
        id: UID
    }

    public struct TraceCapability has key, store {
        id: UID,
        role: Role
    }

    public enum Role has store, copy, drop {
        Manufacturer,
        Distributor,
        Retailer,
        Maintenance,
        Refurbisher,
        Recycler,
        Auditor,
    }

    // Event
    public struct TraceableEvent has drop, store, copy {
        signer_addr: address,
        product_id: String,
        operation: Role,
        uri: String,
        proof: String,
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

    public entry fun grant_vc_issuer_capability(_: &AdminCapability, recipient: address, ctx: &mut TxContext){
        transfer::transfer(VCIssuerCapability {
            id: object::new(ctx)
        }, recipient);
    }

    public entry fun grant_trace_capability(
        _: &VCIssuerCapability, 
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

    public entry fun trace_event(
        audit_trail_cap: &TraceCapability,
        product_id: String,
        uri: String,
        proof: String,
        optional_data: String,
        previous_tx: String,
        ctx: &mut TxContext
    ) {
        event::emit<TraceableEvent>( TraceableEvent {
            signer_addr: tx_context::sender(ctx),
            product_id,
            operation: audit_trail_cap.role,
            uri,
            proof,
            optional_data,
            previous_tx,
            timestamp: ctx.epoch_timestamp_ms()
        });
    }
}

