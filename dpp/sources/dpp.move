
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
        uris: vector<String>, 
        proofs: vector<String>,
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
        uris: vector<String>,
        proofs: vector<String>,
        optional_data: String,
        previous_tx: String,
        ctx: &mut TxContext
    ) {
        event::emit<TraceableEvent>( TraceableEvent {
            signer_addr: tx_context::sender(ctx),
            product_id,
            operation: audit_trail_cap.role,
            uris,
            proofs,
            optional_data,
            previous_tx,
            timestamp: ctx.epoch_timestamp_ms()
        });
    }

    #[test]
    fun test_grant_vc_issuer_capability() {
        use sui::test_scenario;

        let admin: address = @0xAD;
        let vc: address = @0x01;

        let mut scenario = test_scenario::begin(admin);
        {
            init(scenario.ctx());
        };

        scenario.next_tx(admin);
        {
            let adminCapability = scenario.take_from_sender<AdminCapability>();
            grant_vc_issuer_capability(&adminCapability, vc, scenario.ctx());
            scenario.return_to_sender(adminCapability);
            
        };

        scenario.end();
    }

    #[test]
    fun test_grant_admin_capability() {
        use sui::test_scenario;

        let admin: address = @0xAD;
        let new_admin: address = @0x01;

        let mut scenario = test_scenario::begin(admin);
        {
            init(scenario.ctx());
        };

        scenario.next_tx(admin);
        {
            let adminCapability = scenario.take_from_sender<AdminCapability>();
            grant_admin_capability(&adminCapability, new_admin, scenario.ctx());
            scenario.return_to_sender(adminCapability);
            
        };

        scenario.end();
    }

    #[test]
    #[expected_failure (abort_code = EINVALID_ROLE)]
    fun fail_grant_trace_capability() {
        use sui::test_scenario;

        let admin: address = @0xAD;
        let vc_issuer: address = @0x01;
        let recipient: address = @0x02;

        let mut scenario = test_scenario::begin(admin);
        {
            init(scenario.ctx());
        };

        scenario.next_tx(admin);
        {
            let admin_capability = scenario.take_from_sender<AdminCapability>();
            grant_vc_issuer_capability(&admin_capability, vc_issuer, scenario.ctx());
            scenario.return_to_sender(admin_capability);
        };

        scenario.next_tx(vc_issuer);
        {
            let vc_issuer_capability = scenario.take_from_sender<VCIssuerCapability>();
            let role_str = utf8(b"INVALID ROLE"); 
            grant_trace_capability(&vc_issuer_capability, recipient, role_str, scenario.ctx());
            scenario.return_to_sender(vc_issuer_capability);
        };

        scenario.end();
    }


    #[test]
    fun test_trace_event() {
        use sui::test_scenario;

        let admin: address = @0xAD;
        let vc_issuer: address = @0x01;
        let trace_user: address = @0x02;

        let mut scenario = test_scenario::begin(admin);
        {
            init(scenario.ctx());
        };

    
        scenario.next_tx(admin);
        {
            let admin_capability = scenario.take_from_sender<AdminCapability>();
            grant_vc_issuer_capability(&admin_capability, vc_issuer, scenario.ctx());
            scenario.return_to_sender(admin_capability);
        };

    
        scenario.next_tx(vc_issuer);
        {
            let vc_issuer_capability = scenario.take_from_sender<VCIssuerCapability>();
            let role_str = utf8(b"manufacturer"); 
            grant_trace_capability(&vc_issuer_capability, trace_user, role_str, scenario.ctx());
            scenario.return_to_sender(vc_issuer_capability);
        };

        scenario.next_tx(trace_user);
        {
            let trace_capability = scenario.take_from_sender<TraceCapability>();
            let product_id = utf8(b"Product123");
            let uris = vector::empty<String>();
            let proofs = vector::empty<String>();
            let optional_data = utf8(b"{}");
            let previous_tx = utf8(b"PreviousTxHash");

            trace_event(
                &trace_capability,
                product_id,
                uris,
                proofs,
                optional_data,
                previous_tx,
                scenario.ctx(),
            );
            scenario.return_to_sender(trace_capability);
        };

        scenario.end();
    }
}

