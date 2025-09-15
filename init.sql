-- Initialize the LMS database

-- Create extensions
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";
CREATE EXTENSION IF NOT EXISTS "pgcrypto";

-- Create enum types
CREATE TYPE user_role AS ENUM ('admin', 'lecturer', 'student');
CREATE TYPE user_status AS ENUM ('active', 'inactive', 'suspended');
CREATE TYPE assignment_status AS ENUM ('draft', 'published', 'closed');
CREATE TYPE submission_status AS ENUM ('pending', 'submitted', 'graded', 'late');
CREATE TYPE enrollment_status AS ENUM ('active', 'completed', 'dropped', 'pending');

-- Users table
CREATE TABLE users (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    email VARCHAR(255) UNIQUE NOT NULL,
    password_hash VARCHAR(255) NOT NULL,
    first_name VARCHAR(100) NOT NULL,
    last_name VARCHAR(100) NOT NULL,
    role user_role NOT NULL DEFAULT 'student',
    status user_status NOT NULL DEFAULT 'active',
    student_id VARCHAR(50) UNIQUE,
    employee_id VARCHAR(50) UNIQUE,
    department VARCHAR(100),
    phone VARCHAR(20),
    date_of_birth DATE,
    profile_picture_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Courses table
CREATE TABLE courses (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    course_code VARCHAR(20) UNIQUE NOT NULL,
    credits INTEGER NOT NULL DEFAULT 3,
    semester VARCHAR(20) NOT NULL,
    year INTEGER NOT NULL,
    lecturer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    max_students INTEGER DEFAULT 50,
    syllabus TEXT,
    is_active BOOLEAN DEFAULT true,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Enrollments table
CREATE TABLE enrollments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    status enrollment_status NOT NULL DEFAULT 'pending',
    enrolled_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    completed_at TIMESTAMP WITH TIME ZONE,
    grade VARCHAR(5),
    UNIQUE(student_id, course_id)
);

-- Assignments table
CREATE TABLE assignments (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    title VARCHAR(255) NOT NULL,
    description TEXT,
    course_id UUID NOT NULL REFERENCES courses(id) ON DELETE CASCADE,
    lecturer_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status assignment_status NOT NULL DEFAULT 'draft',
    max_points INTEGER NOT NULL DEFAULT 100,
    due_date TIMESTAMP WITH TIME ZONE NOT NULL,
    instructions TEXT,
    allowed_file_types TEXT[] DEFAULT ARRAY['pdf', 'doc', 'docx', 'txt'],
    max_file_size INTEGER DEFAULT 10485760, -- 10MB in bytes
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Submissions table
CREATE TABLE submissions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    assignment_id UUID NOT NULL REFERENCES assignments(id) ON DELETE CASCADE,
    student_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    status submission_status NOT NULL DEFAULT 'pending',
    file_url TEXT,
    file_name VARCHAR(255),
    file_size INTEGER,
    content TEXT,
    points_earned INTEGER,
    feedback TEXT,
    submitted_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP,
    graded_at TIMESTAMP WITH TIME ZONE,
    graded_by UUID REFERENCES users(id),
    UNIQUE(assignment_id, student_id)
);

-- Notifications table
CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    type VARCHAR(50) NOT NULL DEFAULT 'info',
    is_read BOOLEAN DEFAULT false,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT CURRENT_TIMESTAMP
);

-- Create indexes for better performance
CREATE INDEX idx_users_email ON users(email);
CREATE INDEX idx_users_role ON users(role);
CREATE INDEX idx_users_status ON users(status);
CREATE INDEX idx_courses_lecturer_id ON courses(lecturer_id);
CREATE INDEX idx_courses_code ON courses(course_code);
CREATE INDEX idx_enrollments_student_id ON enrollments(student_id);
CREATE INDEX idx_enrollments_course_id ON enrollments(course_id);
CREATE INDEX idx_assignments_course_id ON assignments(course_id);
CREATE INDEX idx_assignments_lecturer_id ON assignments(lecturer_id);
CREATE INDEX idx_submissions_assignment_id ON submissions(assignment_id);
CREATE INDEX idx_submissions_student_id ON submissions(student_id);
CREATE INDEX idx_notifications_user_id ON notifications(user_id);
CREATE INDEX idx_notifications_is_read ON notifications(is_read);

-- Create updated_at trigger function
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = CURRENT_TIMESTAMP;
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create triggers for updated_at
CREATE TRIGGER update_users_updated_at BEFORE UPDATE ON users FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_courses_updated_at BEFORE UPDATE ON courses FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();
CREATE TRIGGER update_assignments_updated_at BEFORE UPDATE ON assignments FOR EACH ROW EXECUTE FUNCTION update_updated_at_column();

-- Insert seed data

-- Insert admin user
INSERT INTO users (email, password_hash, first_name, last_name, role, employee_id, department) VALUES
('admin@university.edu', crypt('admin123', gen_salt('bf')), 'System', 'Administrator', 'admin', 'EMP001', 'IT Department');

-- Insert lecturers
INSERT INTO users (email, password_hash, first_name, last_name, role, employee_id, department) VALUES
('john.smith@university.edu', crypt('lecturer123', gen_salt('bf')), 'John', 'Smith', 'lecturer', 'EMP002', 'Computer Science'),
('jane.doe@university.edu', crypt('lecturer123', gen_salt('bf')), 'Jane', 'Doe', 'lecturer', 'EMP003', 'Mathematics'),
('mike.johnson@university.edu', crypt('lecturer123', gen_salt('bf')), 'Mike', 'Johnson', 'lecturer', 'EMP004', 'Physics');

-- Insert students
INSERT INTO users (email, password_hash, first_name, last_name, role, student_id, department) VALUES
('alice.wilson@student.edu', crypt('student123', gen_salt('bf')), 'Alice', 'Wilson', 'student', 'STU001', 'Computer Science'),
('bob.brown@student.edu', crypt('student123', gen_salt('bf')), 'Bob', 'Brown', 'student', 'STU002', 'Computer Science'),
('carol.davis@student.edu', crypt('student123', gen_salt('bf')), 'Carol', 'Davis', 'student', 'STU003', 'Mathematics'),
('david.miller@student.edu', crypt('student123', gen_salt('bf')), 'David', 'Miller', 'student', 'STU004', 'Physics'),
('eva.garcia@student.edu', crypt('student123', gen_salt('bf')), 'Eva', 'Garcia', 'student', 'STU005', 'Computer Science');

-- Insert courses
INSERT INTO courses (title, description, course_code, credits, semester, year, lecturer_id, syllabus) VALUES
('Introduction to Programming', 'Learn the fundamentals of programming using Python', 'CS101', 3, 'Fall', 2024, 
 (SELECT id FROM users WHERE email = 'john.smith@university.edu'),
 'Week 1: Variables and Data Types\nWeek 2: Control Structures\nWeek 3: Functions\nWeek 4: Object-Oriented Programming'),
('Data Structures and Algorithms', 'Advanced programming concepts and algorithm design', 'CS201', 4, 'Spring', 2024,
 (SELECT id FROM users WHERE email = 'john.smith@university.edu'),
 'Week 1: Arrays and Linked Lists\nWeek 2: Stacks and Queues\nWeek 3: Trees and Graphs\nWeek 4: Sorting and Searching'),
('Calculus I', 'Introduction to differential and integral calculus', 'MATH101', 4, 'Fall', 2024,
 (SELECT id FROM users WHERE email = 'jane.doe@university.edu'),
 'Week 1: Limits\nWeek 2: Derivatives\nWeek 3: Applications of Derivatives\nWeek 4: Integrals'),
('Physics I', 'Classical mechanics and thermodynamics', 'PHYS101', 4, 'Fall', 2024,
 (SELECT id FROM users WHERE email = 'mike.johnson@university.edu'),
 'Week 1: Kinematics\nWeek 2: Dynamics\nWeek 3: Energy and Momentum\nWeek 4: Thermodynamics');

-- Insert enrollments
INSERT INTO enrollments (student_id, course_id, status) VALUES
((SELECT id FROM users WHERE email = 'alice.wilson@student.edu'), (SELECT id FROM courses WHERE course_code = 'CS101'), 'active'),
((SELECT id FROM users WHERE email = 'alice.wilson@student.edu'), (SELECT id FROM courses WHERE course_code = 'MATH101'), 'active'),
((SELECT id FROM users WHERE email = 'bob.brown@student.edu'), (SELECT id FROM courses WHERE course_code = 'CS101'), 'active'),
((SELECT id FROM users WHERE email = 'bob.brown@student.edu'), (SELECT id FROM courses WHERE course_code = 'CS201'), 'active'),
((SELECT id FROM users WHERE email = 'carol.davis@student.edu'), (SELECT id FROM courses WHERE course_code = 'MATH101'), 'active'),
((SELECT id FROM users WHERE email = 'david.miller@student.edu'), (SELECT id FROM courses WHERE course_code = 'PHYS101'), 'active'),
((SELECT id FROM users WHERE email = 'eva.garcia@student.edu'), (SELECT id FROM courses WHERE course_code = 'CS101'), 'active');

-- Insert assignments
INSERT INTO assignments (title, description, course_id, lecturer_id, status, max_points, due_date, instructions) VALUES
('Python Basics Assignment', 'Complete exercises on variables, loops, and functions', 
 (SELECT id FROM courses WHERE course_code = 'CS101'),
 (SELECT id FROM users WHERE email = 'john.smith@university.edu'),
 'published', 100, CURRENT_TIMESTAMP + INTERVAL '7 days',
 'Complete all exercises in the provided Python notebook. Submit your .py file with solutions.'),
('Algorithm Analysis', 'Analyze time complexity of given algorithms',
 (SELECT id FROM courses WHERE course_code = 'CS201'),
 (SELECT id FROM users WHERE email = 'john.smith@university.edu'),
 'published', 150, CURRENT_TIMESTAMP + INTERVAL '10 days',
 'Provide Big O analysis for each algorithm. Include written explanations and code examples.'),
('Derivative Problems', 'Solve calculus problems involving derivatives',
 (SELECT id FROM courses WHERE course_code = 'MATH101'),
 (SELECT id FROM users WHERE email = 'jane.doe@university.edu'),
 'published', 100, CURRENT_TIMESTAMP + INTERVAL '5 days',
 'Show all work for each problem. Submit handwritten solutions as PDF.'),
('Lab Report: Motion', 'Physics lab report on projectile motion',
 (SELECT id FROM courses WHERE course_code = 'PHYS101'),
 (SELECT id FROM users WHERE email = 'mike.johnson@university.edu'),
 'published', 120, CURRENT_TIMESTAMP + INTERVAL '14 days',
 'Include data analysis, graphs, and conclusions. Follow the lab report template.');

-- Insert sample notifications
INSERT INTO notifications (user_id, title, message, type) VALUES
((SELECT id FROM users WHERE email = 'alice.wilson@student.edu'), 'New Assignment Posted', 'Python Basics Assignment has been posted for CS101', 'assignment'),
((SELECT id FROM users WHERE email = 'bob.brown@student.edu'), 'Grade Posted', 'Your grade for Algorithm Analysis has been posted', 'grade'),
((SELECT id FROM users WHERE email = 'john.smith@university.edu'), 'New Enrollment', 'A new student has enrolled in your CS101 course', 'enrollment');

COMMIT;