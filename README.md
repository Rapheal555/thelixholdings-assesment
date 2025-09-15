# University Learning Management System (LMS)

A comprehensive Learning Management System built with modern web technologies, featuring role-based access control, course management, assignment handling, and AI-powered features.

## 🚀 Features

### Core Functionality
- **User Management**: Role-based authentication (Admin, Lecturer, Student)
- **Course Management**: Create, manage, and enroll in courses
- **Assignment System**: Create assignments, submit work, and grade submissions
- **File Upload**: Support for various file types with size restrictions
- **Notifications**: Real-time notifications for important events

### AI-Powered Features
- **Course Recommendations**: AI-driven course suggestions based on user preferences
- **Syllabus Generation**: Automated syllabus creation using AI
- **Content Analysis**: AI-powered analysis of submissions and content

### Technical Features
- **Responsive Design**: Mobile-first responsive UI
- **Real-time Updates**: Live notifications and updates
- **File Management**: Secure file upload and storage
- **Caching**: Redis-based caching for improved performance
- **Containerization**: Docker support for easy deployment

## 🛠 Technology Stack

### Frontend
- **Next.js 14** - React framework with App Router
- **TypeScript** - Type-safe JavaScript
- **Tailwind CSS** - Utility-first CSS framework
- **shadcn/ui** - Modern UI components
- **NextAuth.js** - Authentication solution

### Backend
- **NestJS** - Progressive Node.js framework
- **TypeScript** - Type-safe JavaScript
- **TypeORM** - Object-Relational Mapping
- **PostgreSQL** - Primary database
- **Redis** - Caching and session storage
- **JWT** - JSON Web Tokens for authentication

### DevOps
- **Docker** - Containerization
- **Docker Compose** - Multi-container orchestration

## 📋 Prerequisites

Before running this application, make sure you have the following installed:

- **Node.js** (v18 or higher)
- **npm** or **yarn**
- **Docker** and **Docker Compose**
- **Git**

## 🚀 Quick Start

### Option 1: Docker Compose (Recommended)

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd thelixholdings-assesment
   ```

2. **Start the application**
   ```bash
   docker-compose up -d
   ```

3. **Access the application**
   - Frontend: http://localhost:3000
   - Backend API: http://localhost:3007
   - API Documentation: http://localhost:3007/api/docs

### Option 2: Manual Setup

#### Backend Setup

1. **Navigate to backend directory**
   ```bash
   cd backend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env
   # Edit .env with your configuration
   ```

4. **Set up PostgreSQL database**
   - Create a PostgreSQL database
   - Update database credentials in `.env`
   - Run the init.sql script to set up the schema

5. **Start the backend server**
   ```bash
   npm run start:dev
   ```

#### Frontend Setup

1. **Navigate to frontend directory**
   ```bash
   cd frontend
   ```

2. **Install dependencies**
   ```bash
   npm install
   ```

3. **Set up environment variables**
   ```bash
   cp .env.example .env.local
   # Edit .env.local with your configuration
   ```

4. **Start the frontend server**
   ```bash
   npm run dev
   ```

## 🔧 Configuration

### Backend Environment Variables

```env
# Database Configuration
DATABASE_URL=postgresql://lms_user:lms_password@postgres:5432/lms_db
DB_HOST=postgres
DB_PORT=5432
DB_USERNAME=lms_user
DB_PASSWORD=lms_password
DB_NAME=lms_db

# JWT Configuration
JWT_SECRET=your-super-secret-jwt-key
JWT_EXPIRES_IN=24h

# Application Configuration
PORT=3007
NODE_ENV=development
FRONTEND_URL=http://localhost:3000

# OpenAI Configuration (Optional)
OPENAI_API_KEY=your-openai-api-key

# Redis Configuration
REDIS_HOST=redis
REDIS_PORT=6379
```

### Frontend Environment Variables

```env
# API Configuration
NEXT_PUBLIC_API_URL=http://localhost:3007/api
NEXT_PUBLIC_BACKEND_URL=http://localhost:3007

# Application Configuration
NEXT_PUBLIC_APP_NAME=University LMS
NEXT_PUBLIC_APP_VERSION=1.0.0

# Authentication
NEXTAUTH_SECRET=your-nextauth-secret
NEXTAUTH_URL=http://localhost:3000
```

## 👥 Default Users

The system comes with pre-configured users for testing:

### Admin
- **Email**: admin@university.edu
- **Password**: admin123
- **Role**: Administrator

### Lecturers
- **Email**: john.smith@university.edu
- **Password**: lecturer123
- **Role**: Lecturer

- **Email**: jane.doe@university.edu
- **Password**: lecturer123
- **Role**: Lecturer

### Students
- **Email**: alice.johnson@student.university.edu
- **Password**: student123
- **Role**: Student

- **Email**: bob.wilson@student.university.edu
- **Password**: student123
- **Role**: Student

## 📚 API Documentation

Once the backend is running, you can access the interactive API documentation at:
- **Swagger UI**: http://localhost:3007/api/docs

### Key API Endpoints

#### Authentication
- `POST /api/auth/login` - User login
- `POST /api/auth/register` - User registration
- `GET /api/auth/profile` - Get user profile

#### Courses
- `GET /api/courses` - List all courses
- `POST /api/courses` - Create a new course
- `GET /api/courses/:id` - Get course details
- `POST /api/courses/:id/enroll` - Enroll in a course

#### Assignments
- `GET /api/assignments` - List assignments
- `POST /api/assignments` - Create assignment
- `POST /api/assignments/:id/submit` - Submit assignment

#### AI Features
- `POST /api/ai/recommend-courses` - Get course recommendations
- `POST /api/ai/generate-syllabus` - Generate course syllabus

## 🗂 Project Structure

```
thelixholdings-assesment/
├── backend/                 # NestJS backend application
│   ├── src/
│   │   ├── auth/           # Authentication module
│   │   ├── users/          # User management
│   │   ├── courses/        # Course management
│   │   ├── assignments/    # Assignment system
│   │   ├── enrollments/    # Enrollment management
│   │   ├── ai/            # AI integration
│   │   └── common/        # Shared utilities
│   ├── Dockerfile
│   └── package.json
├── frontend/               # Next.js frontend application
│   ├── src/
│   │   ├── app/           # App Router pages
│   │   ├── components/    # Reusable components
│   │   ├── lib/          # Utilities and configurations
│   │   └── types/        # TypeScript type definitions
│   ├── Dockerfile
│   └── package.json
├── docker-compose.yml      # Docker Compose configuration
├── init.sql               # Database initialization script
├── SYSTEM_DESIGN.md       # System design documentation
└── README.md              # This file
```

## 🧪 Testing

### Backend Testing
```bash
cd backend
npm run test          # Unit tests
npm run test:e2e      # End-to-end tests
npm run test:cov      # Test coverage
```

### Frontend Testing
```bash
cd frontend
npm run test          # Jest tests
npm run test:watch    # Watch mode
```

## 🚀 Deployment

### Production Deployment with Docker

1. **Build production images**
   ```bash
   docker-compose -f docker-compose.prod.yml build
   ```

2. **Deploy to production**
   ```bash
   docker-compose -f docker-compose.prod.yml up -d
   ```

### Environment-Specific Configurations

- **Development**: Use `docker-compose.yml`
- **Production**: Use `docker-compose.prod.yml` (create based on requirements)
- **Testing**: Use `docker-compose.test.yml` (create for CI/CD)

## 🔍 Troubleshooting

### Common Issues

1. **Database Connection Issues**
   - Ensure PostgreSQL is running
   - Check database credentials in `.env`
   - Verify network connectivity

2. **Port Conflicts**
   - Check if ports 3000, 3007, 5432, 6379 are available
   - Modify port configurations in docker-compose.yml if needed

3. **File Upload Issues**
   - Check file size limits
   - Verify allowed file types
   - Ensure upload directory permissions

### Logs

```bash
# View all logs
docker-compose logs

# View specific service logs
docker-compose logs backend
docker-compose logs frontend
docker-compose logs postgres
```

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Commit your changes (`git commit -m 'Add some amazing feature'`)
4. Push to the branch (`git push origin feature/amazing-feature`)
5. Open a Pull Request

## 📄 License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## 🆘 Support

If you encounter any issues or have questions:

1. Check the [troubleshooting section](#-troubleshooting)
2. Review the [system design documentation](SYSTEM_DESIGN.md)
3. Check existing issues in the repository
4. Create a new issue with detailed information

## 🎯 Roadmap

- [ ] Mobile application (React Native)
- [ ] Advanced analytics dashboard
- [ ] Integration with external LMS platforms
- [ ] Real-time collaboration features
- [ ] Advanced AI-powered grading
- [ ] Multi-language support
- [ ] Accessibility improvements

---

**Built with ❤️ for modern education**