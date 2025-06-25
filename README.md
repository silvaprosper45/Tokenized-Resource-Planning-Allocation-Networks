# Tokenized Resource Planning Allocation Networks

# Tokenized Resource Planning Allocation Networks

A decentralized resource planning and allocation system built on the Stacks blockchain using Clarity smart contracts. This system enables efficient resource management through verification, forecasting, capacity planning, allocation optimization, and utilization tracking.

## 🏗️ Architecture

The system consists of five interconnected smart contracts:

### 1. Resource Planner Verification (`resource-planner-verification-v1.clar`)
- **Purpose**: Validates and manages resource planners in the network
- **Key Features**:
    - Planner registration with stake requirements (minimum 1 STX)
    - Reputation management based on performance
    - Verification status tracking
    - Statistics and analytics

### 2. Demand Forecasting (`demand-forecasting-v1.clar`)
- **Purpose**: Handles resource demand predictions and validation
- **Key Features**:
    - Forecast submission with confidence levels
    - Accuracy validation against actual demand
    - Historical performance tracking
    - Resource-specific forecasting metrics

### 3. Capacity Planning (`capacity-planning-v1.clar`)
- **Purpose**: Manages resource capacity planning and allocation
- **Key Features**:
    - Resource capacity registration
    - Capacity reservation system
    - Dynamic availability tracking
    - Multi-user reservation management

### 4. Allocation Optimization (`allocation-optimization-v1.clar`)
- **Purpose**: Optimizes resource allocation based on demand and capacity
- **Key Features**:
    - Priority-based allocation requests
    - Optimization algorithms
    - Efficiency scoring
    - Request approval/rejection workflow

### 5. Utilization Tracking (`utilization-tracking-v1.clar`)
- **Purpose**: Tracks resource utilization and performance metrics
- **Key Features**:
    - Real-time utilization reporting
    - Performance metrics tracking
    - Historical analysis
    - Resource scoring system

## 🚀 Getting Started

### Prerequisites
- Stacks blockchain development environment
- Clarity CLI tools
- Node.js and npm for testing

### Installation

1. Clone the repository:
   \`\`\`bash
   git clone <repository-url>
   cd tokenized-resource-planning
   \`\`\`

2. Install dependencies:
   \`\`\`bash
   npm install
   \`\`\`

3. Run tests:
   \`\`\`bash
   npm test
   \`\`\`

### Deployment

Deploy contracts to Stacks testnet:

\`\`\`bash
# Deploy resource planner verification
clarinet deploy --testnet contracts/resource-planner-verification-v1.clar

# Deploy demand forecasting
clarinet deploy --testnet contracts/demand-forecasting-v1.clar

# Deploy capacity planning
clarinet deploy --testnet contracts/capacity-planning-v1.clar

# Deploy allocation optimization
clarinet deploy --testnet contracts/allocation-optimization-v1.clar

# Deploy utilization tracking
clarinet deploy --testnet contracts/utilization-tracking-v1.clar
\`\`\`

## 📋 Usage Examples

### Register as a Resource Planner

\`\`\`clarity
(contract-call? .resource-planner-verification-v1 register-planner u1000000)
\`\`\`

### Submit a Demand Forecast

\`\`\`clarity
(contract-call? .demand-forecasting-v1 submit-forecast "CPU-001" u202401 u1000 u85)
\`\`\`

### Register Resource Capacity

\`\`\`clarity
(contract-call? .capacity-planning-v1 register-resource-capacity "SERVER-001" u1000)
\`\`\`

### Submit Allocation Request

\`\`\`clarity
(contract-call? .allocation-optimization-v1 submit-allocation-request "CPU-001" u100 u8 u1100)
\`\`\`

### Report Resource Utilization

\`\`\`clarity
(contract-call? .utilization-tracking-v1 report-utilization "SERVER-001" u202401 u1000 u750)
\`\`\`

## 🧪 Testing

The project includes comprehensive test suites using Vitest:

- **Unit Tests**: Individual contract function testing
- **Integration Tests**: Cross-contract interaction testing
- **Performance Tests**: Load and stress testing scenarios

Run specific test suites:

\`\`\`bash
# Run all tests
npm test

# Run specific contract tests
npm test resource-planner-verification
npm test demand-forecasting
npm test capacity-planning
npm test allocation-optimization
npm test utilization-tracking
\`\`\`

##  test capacity-planning
npm test allocation-optimization
npm test utilization-tracking
\`\`\`

## 📊 Contract Interactions

### Data Flow

1. **Planner Registration** → Resource planners register with stake
2. **Demand Forecasting** → Planners submit resource demand predictions
3. **Capacity Planning** → Resource managers register available capacity
4. **Allocation Optimization** → System optimizes resource allocation
5. **Utilization Tracking** → Monitor and report actual resource usage

### Key Metrics

- **Planner Reputation**: Based on forecast accuracy and performance
- **Forecast Accuracy**: Percentage accuracy of demand predictions
- **Capacity Utilization**: Percentage of resource capacity being used
- **Allocation Efficiency**: Optimization score for resource distribution
- **Resource Score**: Combined metric of utilization and performance

## 🔧 Configuration

### Contract Parameters

| Parameter | Default Value | Description |
|-----------|---------------|-------------|
| MIN_STAKE | 1,000,000 µSTX | Minimum stake for planner registration |
| MAX_CONFIDENCE | 100 | Maximum confidence level for forecasts |
| OPTIMAL_UTILIZATION | 70-90% | Target utilization range for efficiency |

### Error Codes

| Code | Contract | Description |
|------|----------|-------------|
| u100-103 | Resource Planner | Authorization and validation errors |
| u200-203 | Demand Forecasting | Forecast submission and validation errors |
| u300-303 | Capacity Planning | Capacity management errors |
| u400-403 | Allocation Optimization | Allocation request errors |
| u500-502 | Utilization Tracking | Utilization reporting errors |

## 🛡️ Security Considerations

- **Stake Requirements**: Planners must stake STX to participate
- **Reputation System**: Performance-based reputation scoring
- **Access Control**: Function-level authorization checks
- **Data Validation**: Input validation for all contract calls
- **Overflow Protection**: Safe arithmetic operations

## 🔄 Upgrade Path

The system is designed with versioning in mind:

- Contract names include version numbers (v1)
- Future versions can be deployed alongside existing contracts
- Migration functions can be added for data transfer
- Backward compatibility considerations

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch
3. Write tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

### Development Guidelines

- Follow Clarity best practices
- Maintain comprehensive test coverage
- Document all public functions
- Use consistent naming conventions
- Include error handling for edge cases

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🆘 Support

For questions and support:

- Create an issue in the GitHub repository
- Join our Discord community
- Check the documentation wiki
- Review existing test cases for usage examples

## 🗺️ Roadmap

### Version 2.0 Features
- Advanced optimization algorithms
- Multi-resource allocation
- Automated capacity scaling
- Integration with external oracles
- Enhanced analytics dashboard

### Future Enhancements
- Cross-chain resource sharing
- Machine learning forecasting
- Real-time monitoring dashboard
- API gateway for external integrations
- Mobile application support

