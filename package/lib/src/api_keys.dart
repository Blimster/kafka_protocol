part of kafka_protocol;

class ApiKey {
  static final produce = ApiKey._(0, 'Produce');
  static final fetch = ApiKey._(1, 'Fetch');
  static final listOffsets = ApiKey._(2, 'ListOffsets');
  static final metadata = ApiKey._(3, 'Metadata');
  static final leaderAndIsr = ApiKey._(4, 'LeaderAndIsr');
  static final stopReplica = ApiKey._(5, 'StopReplica');
  static final updateMetadata = ApiKey._(6, 'UpdateMetadata');
  static final controlledShutdown = ApiKey._(7, 'ControlledShutdown');
  static final offsetCommit = ApiKey._(8, 'OffsetCommit');
  static final offsetFetch = ApiKey._(9, 'OffsetFetch');
  static final findCoordinator = ApiKey._(10, 'FindCoordinator');
  static final joinGroup = ApiKey._(11, 'JoinGroup');
  static final heartbeat = ApiKey._(12, 'Heartbeat');
  static final leaveGroup = ApiKey._(13, 'LeaveGroup');
  static final syncGroup = ApiKey._(14, 'SyncGroup');
  static final describeGroups = ApiKey._(15, 'DescribeGroups');
  static final listGroups = ApiKey._(16, 'ListGroups');
  static final saslHandshake = ApiKey._(17, 'SaslHandshake');
  static final apiVersions = ApiKey._(18, 'ApiVersions');
  static final createTopics = ApiKey._(19, 'CreateTopics');
  static final deleteTopics = ApiKey._(20, 'DeleteTopics');
  static final deleteRecords = ApiKey._(21, 'DeleteRecords');
  static final initProducerId = ApiKey._(22, 'InitProducerId');
  static final offsetForLeaderEpoch = ApiKey._(23, 'OffsetForLeaderEpoch');
  static final addPartitionsToTxn = ApiKey._(24, 'AddPartitionsToTxn');
  static final addOffsetsToTxn = ApiKey._(25, 'AddOffsetsToTxn');
  static final endTxn = ApiKey._(26, 'EndTxn');
  static final writeTxnMarkers = ApiKey._(27, 'WriteTxnMarkers');
  static final txnOffsetCommit = ApiKey._(28, 'TxnOffsetCommit');
  static final describeAcls = ApiKey._(29, 'DescribeAcls');
  static final createAcls = ApiKey._(30, 'CreateAcls');
  static final deleteAcls = ApiKey._(31, 'DeleteAcls');
  static final describeConfigs = ApiKey._(32, 'DescribeConfigs');
  static final alterConfigs = ApiKey._(33, 'AlterConfigs');
  static final alterReplicaLogDirs = ApiKey._(34, 'AlterReplicaLogDirs');
  static final describeLogDirs = ApiKey._(35, 'DescribeLogDirs');
  static final saslAuthenticate = ApiKey._(36, 'SaslAuthenticate');
  static final createPartitions = ApiKey._(37, 'CreatePartitions');
  static final createDelegationToken = ApiKey._(38, 'CreateDelegationToken');
  static final renewDelegationToken = ApiKey._(39, 'RenewDelegationToken');
  static final expireDelegationToken = ApiKey._(40, 'ExpireDelegationToken');
  static final describeDelegationToken =
      ApiKey._(41, 'DescribeDelegationToken');
  static final deleteGroups = ApiKey._(42, 'DeleteGroups');
  static final electLeaders = ApiKey._(43, 'ElectLeaders');
  static final incrementalAlterConfigs =
      ApiKey._(44, 'IncrementalAlterConfigs');
  static final alterPartitionReassignments =
      ApiKey._(45, 'AlterPartitionReassignments');
  static final listPartitionReassignments =
      ApiKey._(46, 'ListPartitionReassignments');
  static final offsetDelete = ApiKey._(47, 'OffsetDelete');
  static final describeClientQuotas = ApiKey._(48, 'DescribeClientQuotas');
  static final alterClientQuotas = ApiKey._(49, 'AlterClientQuotas');
  static final describeUserScramCredentials =
      ApiKey._(50, 'DescribeUserScramCredentials');
  static final alterUserScramCredentials =
      ApiKey._(51, 'AlterUserScramCredentials');
  static final alterIsr = ApiKey._(56, 'AlterIsr');
  static final updateFeatures = ApiKey._(57, 'UpdateFeatures');
  static final describeCluster = ApiKey._(60, 'DescribeCluster');
  static final describeProducers = ApiKey._(61, 'DescribeProducers');
  static final describeTransactions = ApiKey._(65, 'DescribeTransactions');
  static final listTransactions = ApiKey._(66, 'ListTransactions');
  static final allocateProducerIds = ApiKey._(67, 'AllocateProducerIds');

  final KInt16 key;
  final String name;

  ApiKey._(int apiKey, this.name) : key = KInt16(apiKey);
}
