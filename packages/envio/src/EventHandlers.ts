/*
 * Please refer to https://docs.envio.dev for a thorough guide on all Envio indexer features
 * This file is auto-generated from scaffold-eth contracts
 */
import {
  MockPYUSD,
  MockPYUSD_Approval,
  MockPYUSD_Transfer,
  ProtocolContract,
  ProtocolContract_DisputeCreated,
  ProtocolContract_DisputeResolved,
  ProtocolContract_JudgeRegistered,
  FactoryContract,
  FactoryContract_MarketplaceDeployed,
  MarketplaceInstance,
  MarketplaceInstance_UserRegistered,
  MarketplaceInstance_DealCreated,
  MarketplaceInstance_DealAccepted,
  MarketplaceInstance_DealRejected,
  MarketplaceInstance_DealFinalized,
  MarketplaceInstance_DealAmountUpdated,
  MarketplaceInstance_DealDurationUpdated,
  MarketplaceInstance_DisputeCreated,
  MarketplaceInstance_DisputeResolved,
  MarketplaceInstance_UserWithdrew,
  MarketplaceInstance_PaymentDeposited,
  MarketplaceInstance_AavePoolSet,
  MarketplaceInstance_NewFeePercent,
  MarketplaceInstance_OwnerWithdrawFromAaver,
  MockAavePool,
  MockAavePool_Supplied,
  MockAavePool_Withdrawn,
  User,
  Deal,
  Dispute,
  Judge,
  Marketplace,
} from "generated";

// MockPYUSD Event Handlers
MockPYUSD.Approval.handler(async ({ event, context }) => {
  const entity: MockPYUSD_Approval = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    owner: event.params.owner,
    spender: event.params.spender,
    value: event.params.value,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MockPYUSD_Approval.set(entity);
});

MockPYUSD.Transfer.handler(async ({ event, context }) => {
  const entity: MockPYUSD_Transfer = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    from: event.params.from,
    to: event.params.to,
    value: event.params.value,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MockPYUSD_Transfer.set(entity);
});

// ProtocolContract Event Handlers
ProtocolContract.DisputeCreated.handler(async ({ event, context }) => {
  const entity: ProtocolContract_DisputeCreated = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    disputeId: event.params.disputeId,
    requester: event.params.requester,
    contractAddress: event.params.contractAddress,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.ProtocolContract_DisputeCreated.set(entity);
});

ProtocolContract.DisputeResolved.handler(async ({ event, context }) => {
  const entity: ProtocolContract_DisputeResolved = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    disputeId: event.params.disputeId,
    winner: event.params.winner,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.ProtocolContract_DisputeResolved.set(entity);
});

ProtocolContract.JudgeRegistered.handler(async ({ event, context }) => {
  const entity: ProtocolContract_JudgeRegistered = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    judge: event.params.judge,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.ProtocolContract_JudgeRegistered.set(entity);

  // Create or update Judge entity
  let judge = await context.Judge.get(event.params.judge);
  if (!judge) {
    judge = {
      id: event.params.judge,
      address: event.params.judge,
      balance: BigInt(0),
      reputation: BigInt(0),
      totalVotes: BigInt(0),
      correctVotes: BigInt(0),
      createdAt: BigInt(event.block.timestamp),
      updatedAt: BigInt(event.block.timestamp),
    };
  } else {
    judge = {
      ...judge,
      updatedAt: BigInt(event.block.timestamp),
    };
  }
  context.Judge.set(judge);
});

// FactoryContract Event Handlers
FactoryContract.MarketplaceDeployed.handler(async ({ event, context }) => {
  const entity: FactoryContract_MarketplaceDeployed = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    marketplace: event.params.marketplace,
    creator: event.params.creator,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.FactoryContract_MarketplaceDeployed.set(entity);

  // Create Marketplace entity
  const marketplace: Marketplace = {
    id: event.params.marketplace,
    address: event.params.marketplace,
    creator: event.params.creator,
    feePercent: BigInt(0), // Will be updated when setFeePercent is called
    token: "", // Will be updated when marketplace is initialized
    totalDeals: BigInt(0),
    totalVolume: BigInt(0),
    createdAt: BigInt(event.block.timestamp),
    updatedAt: BigInt(event.block.timestamp),
  };

  context.Marketplace.set(marketplace);
});

// MarketplaceInstance Event Handlers
MarketplaceInstance.UserRegistered.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_UserRegistered = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    user: event.params.user,
    isPayer: event.params.isPayer,
    isBeneficiary: event.params.isBeneficiary,
    isJudge: event.params.isJudge,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_UserRegistered.set(entity);

  // Create or update User entity
  let user = await context.User.get(event.params.user);
  if (!user) {
    user = {
      id: event.params.user,
      address: event.params.user,
      isPayer: event.params.isPayer,
      isBeneficiary: event.params.isBeneficiary,
      isJudge: event.params.isJudge,
      balance: BigInt(0),
      reputationAsUser: BigInt(0),
      reputationAsJudge: BigInt(0),
      totalDeals: BigInt(0),
      totalVolume: BigInt(0),
      createdAt: BigInt(event.block.timestamp),
      updatedAt: BigInt(event.block.timestamp),
    };
  } else {
    user = {
      ...user,
      isPayer: user.isPayer || event.params.isPayer,
      isBeneficiary: user.isBeneficiary || event.params.isBeneficiary,
      isJudge: user.isJudge || event.params.isJudge,
      updatedAt: BigInt(event.block.timestamp),
    };
  }
  context.User.set(user);
});

MarketplaceInstance.DealCreated.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DealCreated = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    dealId: event.params.dealId,
    payer: event.params.payer,
    beneficiary: event.params.beneficiary,
    amount: event.params.amount,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DealCreated.set(entity);

  // Create Deal entity
  const deal: Deal = {
    id: event.params.dealId.toString(),
    dealId: event.params.dealId,
    payer: event.params.payer,
    beneficiary: event.params.beneficiary,
    amount: event.params.amount,
    duration: BigInt(0), // Will be updated when duration is set
    startedAt: BigInt(0), // Will be updated when deal is accepted
    accepted: false,
    disputed: false,
    finalized: false,
    createdAt: BigInt(event.block.timestamp),
    updatedAt: BigInt(event.block.timestamp),
  };

  context.Deal.set(deal);

  // Update marketplace stats
  const marketplace = await context.Marketplace.get(event.srcAddress);
  if (marketplace) {
    const updatedMarketplace: Marketplace = {
      ...marketplace,
      totalDeals: marketplace.totalDeals + BigInt(1),
      totalVolume: marketplace.totalVolume + event.params.amount,
      updatedAt: BigInt(event.block.timestamp),
    };
    context.Marketplace.set(updatedMarketplace);
  }
});

MarketplaceInstance.DealAccepted.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DealAccepted = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    dealId: event.params.dealId,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DealAccepted.set(entity);

  // Update Deal entity
  const deal = await context.Deal.get(event.params.dealId.toString());
  if (deal) {
    const updatedDeal: Deal = {
      ...deal,
      accepted: true,
      startedAt: BigInt(event.block.timestamp),
      updatedAt: BigInt(event.block.timestamp),
    };
    context.Deal.set(updatedDeal);
  }
});

MarketplaceInstance.DealRejected.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DealRejected = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    dealId: event.params.dealId,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DealRejected.set(entity);

  // Remove Deal entity (as per contract logic)
  context.Deal.deleteUnsafe(event.params.dealId.toString());
});

MarketplaceInstance.DealFinalized.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DealFinalized = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    dealId: event.params.dealId,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DealFinalized.set(entity);

  // Update Deal entity
  const deal = await context.Deal.get(event.params.dealId.toString());
  if (deal) {
    const updatedDeal: Deal = {
      ...deal,
      finalized: true,
      updatedAt: BigInt(event.block.timestamp),
    };
    context.Deal.set(updatedDeal);
  }
});

MarketplaceInstance.DealAmountUpdated.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DealAmountUpdated = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    dealId: event.params.dealId,
    newAmount: event.params.newAmount,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DealAmountUpdated.set(entity);

  // Update Deal entity
  const deal = await context.Deal.get(event.params.dealId.toString());
  if (deal) {
    const updatedDeal: Deal = {
      ...deal,
      amount: event.params.newAmount,
      updatedAt: BigInt(event.block.timestamp),
    };
    context.Deal.set(updatedDeal);
  }
});

MarketplaceInstance.DealDurationUpdated.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DealDurationUpdated = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    dealId: event.params.dealId,
    newDuration: BigInt(event.params.newDuration),
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DealDurationUpdated.set(entity);

  // Update Deal entity
  const deal = await context.Deal.get(event.params.dealId.toString());
  if (deal) {
    const updatedDeal: Deal = {
      ...deal,
      duration: BigInt(event.params.newDuration),
      updatedAt: BigInt(event.block.timestamp),
    };
    context.Deal.set(updatedDeal);
  }
});

MarketplaceInstance.DisputeCreated.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DisputeCreated = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    dealId: event.params.dealId,
    requester: event.params.requester,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DisputeCreated.set(entity);

  // Update Deal entity
  const deal = await context.Deal.get(event.params.dealId.toString());
  if (deal) {
    const updatedDeal: Deal = {
      ...deal,
      disputed: true,
      updatedAt: BigInt(event.block.timestamp),
    };
    context.Deal.set(updatedDeal);
  }
});

MarketplaceInstance.DisputeResolved.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_DisputeResolved = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    disputeId: event.params.disputeId,
    winner: event.params.winner,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_DisputeResolved.set(entity);
});

MarketplaceInstance.UserWithdrew.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_UserWithdrew = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    user: event.params.user,
    amount: event.params.amount,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_UserWithdrew.set(entity);

  // Update User entity
  const user = await context.User.get(event.params.user);
  if (user) {
    const updatedUser: User = {
      ...user,
      balance: user.balance - event.params.amount,
      updatedAt: BigInt(event.block.timestamp),
    };
    context.User.set(updatedUser);
  }
});

MarketplaceInstance.PaymentDeposited.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_PaymentDeposited = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    user: event.params.user,
    amount: event.params.amount,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_PaymentDeposited.set(entity);

  // Update User entity
  const user = await context.User.get(event.params.user);
  if (user) {
    const updatedUser: User = {
      ...user,
      balance: user.balance + event.params.amount,
      updatedAt: BigInt(event.block.timestamp),
    };
    context.User.set(updatedUser);
  }
});

MarketplaceInstance.AavePoolSet.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_AavePoolSet = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    pool: event.params.pool,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_AavePoolSet.set(entity);
});

MarketplaceInstance.NewFeePercent.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_NewFeePercent = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    newFeePercent: BigInt(event.params.newFeePercent),
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_NewFeePercent.set(entity);

  // Update Marketplace entity
  const marketplace = await context.Marketplace.get(event.srcAddress);
  if (marketplace) {
    const updatedMarketplace: Marketplace = {
      ...marketplace,
      feePercent: BigInt(event.params.newFeePercent),
      updatedAt: BigInt(event.block.timestamp),
    };
    context.Marketplace.set(updatedMarketplace);
  }
});

MarketplaceInstance.OwnerWithdrawFromAaver.handler(async ({ event, context }) => {
  const entity: MarketplaceInstance_OwnerWithdrawFromAaver = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    amount: event.params.amount,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MarketplaceInstance_OwnerWithdrawFromAaver.set(entity);
});

// MockAavePool Event Handlers
MockAavePool.Supplied.handler(async ({ event, context }) => {
  const entity: MockAavePool_Supplied = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    asset: event.params.asset,
    amount: event.params.amount,
    onBehalfOf: event.params.onBehalfOf,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MockAavePool_Supplied.set(entity);
});

MockAavePool.Withdrawn.handler(async ({ event, context }) => {
  const entity: MockAavePool_Withdrawn = {
    id: `${event.chainId}_${event.block.number}_${event.logIndex}`,
    asset: event.params.asset,
    amount: event.params.amount,
    to: event.params.to,
    blockNumber: BigInt(event.block.number),
    transactionHash: event.transaction.hash,
    timestamp: BigInt(event.block.timestamp),
  };

  context.MockAavePool_Withdrawn.set(entity);
});

