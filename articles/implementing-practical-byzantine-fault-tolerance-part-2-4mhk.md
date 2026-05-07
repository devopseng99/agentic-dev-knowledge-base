---
title: "Implementing Practical Byzantine Fault Tolerance - Part 2"
url: "https://dev.to/szymongib/implementing-practical-byzantine-fault-tolerance-part-2-4mhk"
author: "Szymon Gibała"
category: "byzantine-fault-tolerance"
---
# Implementing Practical Byzantine Fault Tolerance - Part 2
**Author:** Szymon Gibała  **Published:** October 12, 2023

## Overview
Learning implementation of the Practical Byzantine Fault Tolerance Algorithm in Rust, focusing on Key-Value store as application layer, HTTP with JSON communication, Ed25519 signatures.

## Key Concepts

### Architecture Assumptions
- Key-Value store as application layer
- HTTP with JSON for all communication
- Single binary combining KV service and pBFT endpoints
- Core pBFT logic in separate `pbft-core` library
- Ed25519 signatures for message authentication
- Config-file-based node discovery with replica addresses and public keys

### PbftState (Core Data Structure)
```rust
pub enum ReplicaState {
    Replica,
    Leader { sequence: u64 },
    ViewChange,
}

pub struct PbftState {
    pub(crate) replica_state: ReplicaState,
    pub(crate) view: u64,
    pub(crate) high_watermark: u64,
    pub(crate) low_watermark: u64,
    pub(crate) watermark_k: u64,
    pub(crate) last_applied_seq: u64,
    pub(crate) message_store: MessageStore,
    pub(crate) consensus_log: ConsensusLog,
    pub(crate) checkpoint_log: CheckpointLog,
    pub(crate) view_change_log: ViewChangeLog,
    pub(crate) timer: Option<ViewChangeTimer>,
    pub(crate) checkpoints: BTreeMap<u64, String>,
    pub(crate) checkpoint_digests: BTreeMap<u64, CheckpointDigest>,
}
```

### PbftExecutor
```rust
pub struct PbftExecutor {
    event_tx: EventQueue,
    event_rx: Arc<Mutex<Option<tokio::sync::mpsc::Receiver<EventOccurance>>>>,
    backup_queue: tokio::sync::mpsc::UnboundedSender<EventOccurance>,
    node_id: NodeId,
    config: Config,
    pbft_state: Arc<Mutex<PbftState>>,
    state_machine: Arc<RwLock<dyn StateMachie>>,
    keypair: Arc<ed25519_dalek::Keypair>,
    broadcaster: Arc<dyn PbftBroadcaster>,
}
```

### Configuration
```rust
pub struct PbftNodeConfig {
    pub self_id: NodeId,
    pub private_key_path: PathBuf,
    pub nodes: Vec<NodeConfig>,
}

pub struct NodeConfig {
    pub id: NodeId,
    pub addr: String,
    pub public_key: String,
}
```

### Message Signing and Sending
```rust
pub async fn send_msg<T: Serialize>(client: &reqwest::Client, self_id: NodeId, keypair: &ed25519_dalek::Keypair, msg: &T, url: &str) -> Result<()> {
    let body = serde_json::to_vec(msg)?;
    let signature = keypair.sign(&body).to_bytes().to_vec();
    let signature_hex = hex::encode(signature);
    let res = client.post(url)
        .header(REPLICA_ID_HEADER, self_id.0)
        .header(REPLICA_SIGNATURE_HEADER, signature_hex)
        .header(reqwest::header::CONTENT_TYPE, "application/json")
        .body(body).send().await?;
    if res.status().is_success() { Ok(()) }
    else { Err(BroadcastError::UnexpectedStatusError { url: url.to_string(), status_code: res.status() }) }
}
```

### Signature Verification
```rust
pub fn verify_request_signature(&self, replica_id: u64, signature: &str, msg: &[u8]) -> Result<(), crate::error::Error> {
    let peer = &self.nodes_config.nodes[replica_id as usize];
    let pub_key_raw = hex::decode(peer.public_key.as_bytes())?;
    let public_key = PublicKey::from_bytes(&pub_key_raw)?;
    let signature_raw = hex::decode(signature.as_bytes())?;
    let signature = Signature::from_bytes(&signature_raw)?;
    let is_ok = public_key.verify(msg, &signature).is_ok();
    if !is_ok { return Err(crate::error::Error::InvalidSignature); }
    Ok(())
}
```

### State Machine Trait
```rust
pub trait StateMachie: Send + Sync {
    fn apply_operation(&mut self, operation: &Operation) -> OperationResult;
    fn checkpoint(&self, sequence: u64) -> Result<String, Error>;
}
```

### API Endpoints
```rust
let kv_router = Router::new()
    .route("/", post(handle_kv_set))
    .route("/", get(handle_kv_get));
let consensus_int_router = Router::new()
    .route("/execute", post(handle_consensus_pre_prepare))
    .route("/message", post(handle_consensus_message))
    .route("/state", get(handle_state_dump));
```

Full source: https://github.com/Szymongib/pbft-rust
