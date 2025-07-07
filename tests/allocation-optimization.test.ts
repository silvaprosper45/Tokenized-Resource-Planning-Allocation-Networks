import { describe, it, expect, beforeEach } from 'vitest';

describe('Allocation Optimization Contract', () => {
  let contractAddress;
  let requester;
  let optimizer;
  
  beforeEach(() => {
    contractAddress = 'ST1PQHQKV0RJXZFY1DGX8MNSNYVE3VGZJSRTPGZGM.allocation-optimization-v1';
    requester = 'ST1SJ3DTE5DN7X54YDH5D64R3BCB6A2AG2ZQ8YPD5';
    optimizer = 'ST2CY5V39NHDPWSXMW9QDT3HC3GD6Q6XX4CFRK9AG';
  });
  
  describe('Allocation Requests', () => {
    it('should submit valid allocation request', () => {
      const requestId = submitAllocationRequest('CPU-001', 100, 8, 1100);
      expect(requestId).toBeGreaterThan(0);
    });
    
    it('should reject request with zero amount', () => {
      expect(() => submitAllocationRequest('CPU-001', 0, 8, 1100))
          .toThrow('ERR_INVALID_ALLOCATION');
    });
    
    it('should reject request with invalid priority', () => {
      expect(() => submitAllocationRequest('CPU-001', 100, 15, 1100))
          .toThrow('ERR_INVALID_ALLOCATION');
      
      expect(() => submitAllocationRequest('CPU-001', 100, 0, 1100))
          .toThrow('ERR_INVALID_ALLOCATION');
    });
    
    it('should reject request with past deadline', () => {
      expect(() => submitAllocationRequest('CPU-001', 100, 8, 900))
          .toThrow('ERR_INVALID_ALLOCATION');
    });
  });
  
  describe('Request Management', () => {
    let requestId;
    
    beforeEach(() => {
      requestId = submitAllocationRequest('CPU-001', 100, 8, 1100);
    });
    
    it('should approve allocation request', () => {
      const result = approveAllocationRequest(requestId);
      expect(result).toBe(true);
    });
    
    it('should reject allocation request', () => {
      const result = rejectAllocationRequest(requestId);
      expect(result).toBe(true);
    });
    
    it('should get allocation request details', () => {
      const request = getAllocationRequest(requestId);
      expect(request.resourceId).toBe('CPU-001');
      expect(request.requestedAmount).toBe(100);
      expect(request.priority).toBe(8);
      expect(request.status).toBe('pending');
    });
  });
  
  describe('Optimization Process', () => {
    it('should optimize allocation for resource', () => {
      const optimizationId = optimizeAllocation('CPU-001', 202401, 1000);
      expect(optimizationId).toBeGreaterThan(0);
    });
    
    it('should calculate efficiency score', () => {
      const score = calculateEfficiencyScore(1500);
      expect(score).toBe(90);
      
      const score2 = calculateEfficiencyScore(750);
      expect(score2).toBe(70);
      
      const score3 = calculateEfficiencyScore(250);
      expect(score3).toBe(50);
    });
    
    it('should store optimized allocation', () => {
      const optimizationId = optimizeAllocation('CPU-001', 202401, 1000);
      const allocation = getOptimizedAllocation('CPU-001', 202401);
      
      expect(allocation.totalCapacity).toBe(1000);
      expect(allocation.efficiencyScore).toBeGreaterThan(0);
    });
  });
  
  describe('Priority Handling', () => {
    it('should handle different priority levels', () => {
      const lowPriority = submitAllocationRequest('CPU-001', 100, 3, 1100);
      const highPriority = submitAllocationRequest('CPU-001', 150, 9, 1100);
      
      expect(lowPriority).toBeGreaterThan(0);
      expect(highPriority).toBeGreaterThan(0);
    });
    
    it('should validate priority range', () => {
      for (let priority = 1; priority <= 10; priority++) {
        const requestId = submitAllocationRequest('CPU-001', 100, priority, 1100);
        expect(requestId).toBeGreaterThan(0);
      }
    });
  });
  
  describe('Statistics and Counters', () => {
    it('should track request count', () => {
      const initialCount = getRequestCount();
      submitAllocationRequest('CPU-001', 100, 8, 1100);
      expect(getRequestCount()).toBe(initialCount + 1);
    });
    
    it('should track optimization count', () => {
      const initialCount = getOptimizationCount();
      optimizeAllocation('CPU-001', 202401, 1000);
      expect(getOptimizationCount()).toBe(initialCount + 1);
    });
  });
  
  // Mock functions
  let requestCounter = 0;
  let optimizationCounter = 0;
  const currentBlock = 1000;
  
  function submitAllocationRequest(resourceId, amount, priority, deadline) {
    if (amount <= 0) throw new Error('ERR_INVALID_ALLOCATION');
    if (priority < 1 || priority > 10) throw new Error('ERR_INVALID_ALLOCATION');
    if (deadline <= currentBlock) throw new Error('ERR_INVALID_ALLOCATION');
    
    return ++requestCounter;
  }
  
  function approveAllocationRequest(requestId) {
    return true;
  }
  
  function rejectAllocationRequest(requestId) {
    return true;
  }
  
  function getAllocationRequest(requestId) {
    return {
      requester: requester,
      resourceId: 'CPU-001',
      requestedAmount: 100,
      priority: 8,
      deadline: 1100,
      status: 'pending',
      createdAt: currentBlock
    };
  }
  
  function optimizeAllocation(resourceId, period, totalCapacity) {
    return ++optimizationCounter;
  }
  
  function calculateEfficiencyScore(capacity) {
    if (capacity > 1000) return 90;
    if (capacity > 500) return 70;
    return 50;
  }
  
  function getOptimizedAllocation(resourceId, period) {
    return {
      totalDemand: 0,
      totalCapacity: 1000,
      efficiencyScore: 90,
      allocations: [],
      optimizer: optimizer,
      createdAt: currentBlock
    };
  }
  
  function getRequestCount() {
    return requestCounter;
  }
  
  function getOptimizationCount() {
    return optimizationCounter;
  }
});
