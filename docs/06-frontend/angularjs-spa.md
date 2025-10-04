# RentMe AngularJS Frontend Architecture

**Last Updated**: October 4, 2025

## Overview

The RentMe frontend is built as a **Single Page Application (SPA)** using **AngularJS 1.5.11**. This document covers the project structure, patterns, routing, build process, and comparison with modern frameworks.

---

## Frontend Project Structure

```
📂 Production/RentMe.Web.SPA/            ⭐ ANGULARJS FRONTEND
│
├── 📱 app.js                            WHERE: Main app module
│   ⚙️  WHAT: Angular module, routing config
│   📝 LIKE: main.ts in Angular, App.tsx in React
│
├── 🧩 Components/                       WHERE: Reusable UI components
│   ├── AppMenu/                         Navigation menu
│   ├── LoadingSpinner/                  Loading indicator
│   ├── Modals/                          Modal dialogs
│   ├── Wizard/                          Multi-step forms
│   └── (20+ component folders)
│   📝 PATTERN: component.js + template.html
│   ⚙️  LIKE: React components, Vue components
│
├── 🎬 Actions/                          WHERE: Feature modules
│   ├── Account/                         User account pages
│   ├── ManageProperties/                Property management
│   ├── RentalApplications/              Application submission
│   ├── Leases/                          Lease management
│   ├── TenantPayments/                  Rent payment flows
│   └── (30+ action folders)
│   📝 CONTAINS: Controllers, services, views for each feature
│
├── 🔌 Services/                         WHERE: API client services
│   ├── PropertiesService.js             Calls /api/Properties
│   ├── BillingService.js                Calls /api/Billing
│   └── (many more)
│   ⚙️  WHAT: $http wrappers for API calls
│   📝 LIKE: API clients in React (axios), Angular services
│
├── 🎨 Views/                            WHERE: HTML templates
│   ├── index.html                       Main layout
│   ├── home.html                        Home page
│   └── (view templates)
│
├── 📐 Directives/                       WHERE: Custom directives
│   ├── currencyMask.js                  Input formatting
│   ├── dateRangePicker.js               Date selection
│   └── (custom directives)
│   ⚙️  LIKE: React custom hooks, Vue directives
│
├── 🔍 Filters/                          WHERE: Data transformation
│   ├── currencyFilter.js                Format as currency
│   ├── dateFilter.js                    Format dates
│   └── (pipe functions)
│   📝 LIKE: React/Vue filters, Angular pipes
│
├── 🏭 Factories/                        WHERE: Shared state/data
│   └── (data factories)
│   ⚙️  LIKE: React Context, Vuex store
│
└── 📦 assets/                           WHERE: Static files
    ├── css/                             Stylesheets
    ├── img/                             Images
    ├── js/                              Third-party libraries
    └── scss/                            SASS source files
```

---

## AngularJS Component Pattern

### Component Example: Loading Spinner

**File**: `Production/RentMe.Web.SPA/Components/LoadingSpinner/loadingSpinner.js`

```javascript
// 1️⃣ COMPONENT DEFINITION
angular.module('RentMeApp')
    .component('loadingSpinner', {
        // 2️⃣ TEMPLATE
        template: `
            <div ng-if="$ctrl.isLoading" class="loading-overlay">
                <div class="spinner">
                    <i class="fa fa-spinner fa-spin fa-3x"></i>
                    <p>{{ $ctrl.message }}</p>
                </div>
            </div>
        `,

        // 3️⃣ BINDINGS (props in React)
        bindings: {
            isLoading: '<',  // One-way binding (input)
            message: '@'     // String attribute
        },

        // 4️⃣ CONTROLLER (logic)
        controller: function() {
            var $ctrl = this;

            // Default values
            $ctrl.$onInit = function() {
                $ctrl.message = $ctrl.message || 'Loading...';
            };
        }
    });

// Usage in parent component:
// <loading-spinner is-loading="vm.loading" message="Fetching properties..."></loading-spinner>
```

### Comparison to React

```jsx
// Equivalent React component
function LoadingSpinner({ isLoading, message = 'Loading...' }) {
    if (!isLoading) return null;

    return (
        <div className="loading-overlay">
            <div className="spinner">
                <i className="fa fa-spinner fa-spin fa-3x" />
                <p>{message}</p>
            </div>
        </div>
    );
}

// Usage:
// <LoadingSpinner isLoading={loading} message="Fetching properties..." />
```

---

## AngularJS Service Pattern (API Client)

### Service Example: PropertiesService

**File**: `Production/RentMe.Web.SPA/Services/PropertiesService.js`

```javascript
// 1️⃣ SERVICE DEFINITION
angular.module('RentMeApp')
    .factory('PropertiesService', ['$http', 'API_BASE_URL', function($http, API_BASE_URL) {

        // 2️⃣ SERVICE OBJECT
        var service = {
            getProperties: getProperties,
            getProperty: getProperty,
            createProperty: createProperty,
            updateProperty: updateProperty,
            deleteProperty: deleteProperty
        };

        return service;

        // 3️⃣ GET LIST
        function getProperties(page, take, query) {
            return $http({
                method: 'GET',
                url: API_BASE_URL + '/api/Properties',
                params: { page: page, take: take, query: query }
            })
            .then(function(response) {
                return response.data;  // Return just the data
            })
            .catch(function(error) {
                console.error('Error fetching properties:', error);
                throw error;
            });
        }

        // 4️⃣ GET SINGLE
        function getProperty(id) {
            return $http.get(API_BASE_URL + '/api/Properties/' + id)
                .then(function(response) {
                    return response.data;
                });
        }

        // 5️⃣ POST (CREATE)
        function createProperty(propertyData) {
            return $http.post(API_BASE_URL + '/api/Properties', propertyData)
                .then(function(response) {
                    return response.data;
                });
        }

        // 6️⃣ PUT (UPDATE)
        function updateProperty(id, propertyData) {
            return $http.put(API_BASE_URL + '/api/Properties/' + id, propertyData)
                .then(function(response) {
                    return response.data;
                });
        }

        // 7️⃣ DELETE
        function deleteProperty(id) {
            return $http.delete(API_BASE_URL + '/api/Properties/' + id);
        }
    }]);

// Usage in controller:
// PropertiesService.getProperties(0, 15, 'austin')
//     .then(function(properties) {
//         vm.properties = properties;
//     });
```

### Comparison to Modern React

```typescript
// Equivalent React Query + Axios
import { useQuery, useMutation } from '@tanstack/react-query';
import axios from 'axios';

const API_BASE_URL = process.env.REACT_APP_API_URL;

// GET list
export function useProperties(page, take, query) {
    return useQuery({
        queryKey: ['properties', page, take, query],
        queryFn: async () => {
            const { data } = await axios.get(`${API_BASE_URL}/api/Properties`, {
                params: { page, take, query }
            });
            return data;
        }
    });
}

// GET single
export function useProperty(id) {
    return useQuery({
        queryKey: ['property', id],
        queryFn: async () => {
            const { data } = await axios.get(`${API_BASE_URL}/api/Properties/${id}`);
            return data;
        }
    });
}

// POST (create)
export function useCreateProperty() {
    return useMutation({
        mutationFn: async (propertyData) => {
            const { data } = await axios.post(`${API_BASE_URL}/api/Properties`, propertyData);
            return data;
        }
    });
}

// Usage in component:
// const { data: properties, isLoading } = useProperties(0, 15, 'austin');
// const createMutation = useCreateProperty();
```

---

## Routing with UI-Router

### Route Configuration

**File**: `Production/RentMe.Web.SPA/app.js`

```javascript
angular.module('RentMeApp', ['ui.router', 'ui.bootstrap'])
    .config(['$stateProvider', '$urlRouterProvider', function($stateProvider, $urlRouterProvider) {

        // Default route
        $urlRouterProvider.otherwise('/');

        // Define states (routes)
        $stateProvider

            // Home page
            .state('home', {
                url: '/',
                templateUrl: 'Views/home.html',
                controller: 'HomeController',
                controllerAs: 'vm'
            })

            // Property search
            .state('properties', {
                url: '/properties?query&city&state',
                templateUrl: 'Actions/Properties/properties.html',
                controller: 'PropertiesController',
                controllerAs: 'vm'
            })

            // Property details
            .state('property-details', {
                url: '/properties/:id',
                templateUrl: 'Actions/Properties/property-details.html',
                controller: 'PropertyDetailsController',
                controllerAs: 'vm',
                resolve: {
                    // Pre-load property data before showing view
                    property: ['$stateParams', 'PropertiesService', function($stateParams, PropertiesService) {
                        return PropertiesService.getProperty($stateParams.id);
                    }]
                }
            })

            // Dashboard (requires authentication)
            .state('dashboard', {
                url: '/dashboard',
                templateUrl: 'Actions/Dashboard/dashboard.html',
                controller: 'DashboardController',
                controllerAs: 'vm',
                data: {
                    requiresAuth: true  // Custom property for auth check
                }
            })

            // Manage properties
            .state('manage-properties', {
                url: '/manage-properties',
                templateUrl: 'Actions/ManageProperties/manage-properties.html',
                controller: 'ManagePropertiesController',
                controllerAs: 'vm',
                data: {
                    requiresAuth: true,
                    roles: ['Landlord']  // Only landlords can access
                }
            });
    }])

    // Authentication check on state change
    .run(['$rootScope', '$state', 'AuthService', function($rootScope, $state, AuthService) {
        $rootScope.$on('$stateChangeStart', function(event, toState, toParams) {
            if (toState.data && toState.data.requiresAuth) {
                if (!AuthService.isAuthenticated()) {
                    event.preventDefault();
                    $state.go('login');
                }
            }
        });
    }]);
```

### Comparison to React Router

```typescript
// Equivalent React Router v6
import { BrowserRouter, Routes, Route, Navigate } from 'react-router-dom';

function App() {
    return (
        <BrowserRouter>
            <Routes>
                {/* Home page */}
                <Route path="/" element={<HomePage />} />

                {/* Property search */}
                <Route path="/properties" element={<PropertiesPage />} />

                {/* Property details */}
                <Route path="/properties/:id" element={<PropertyDetailsPage />} />

                {/* Dashboard (requires authentication) */}
                <Route path="/dashboard" element={
                    <ProtectedRoute>
                        <DashboardPage />
                    </ProtectedRoute>
                } />

                {/* Manage properties (landlord only) */}
                <Route path="/manage-properties" element={
                    <ProtectedRoute roles={['Landlord']}>
                        <ManagePropertiesPage />
                    </ProtectedRoute>
                } />
            </Routes>
        </BrowserRouter>
    );
}
```

---

## Build Process

### Grunt Configuration

**File**: `Production/RentMe.Web.SPA/Gruntfile.js`

```javascript
module.exports = function(grunt) {
    grunt.initConfig({
        // Concatenate JS files
        concat: {
            dist: {
                src: [
                    'app.js',
                    'Services/**/*.js',
                    'Controllers/**/*.js',
                    'Components/**/*.js',
                    'Directives/**/*.js',
                    'Filters/**/*.js'
                ],
                dest: 'dist/app.bundle.js'
            }
        },

        // Minify JS
        uglify: {
            dist: {
                files: {
                    'dist/app.bundle.min.js': ['dist/app.bundle.js']
                }
            }
        },

        // Compile SASS to CSS
        sass: {
            dist: {
                files: {
                    'assets/css/app.css': 'assets/scss/main.scss'
                }
            }
        },

        // Minify CSS
        cssmin: {
            dist: {
                files: {
                    'dist/app.min.css': ['assets/css/app.css']
                }
            }
        },

        // Watch for changes
        watch: {
            scripts: {
                files: ['**/*.js', '!dist/**'],
                tasks: ['concat', 'uglify']
            },
            styles: {
                files: ['assets/scss/**/*.scss'],
                tasks: ['sass', 'cssmin']
            }
        }
    });

    // Load plugins
    grunt.loadNpmTasks('grunt-contrib-concat');
    grunt.loadNpmTasks('grunt-contrib-uglify');
    grunt.loadNpmTasks('grunt-contrib-sass');
    grunt.loadNpmTasks('grunt-contrib-cssmin');
    grunt.loadNpmTasks('grunt-contrib-watch');

    // Register tasks
    grunt.registerTask('build', ['concat', 'uglify', 'sass', 'cssmin']);
    grunt.registerTask('default', ['build', 'watch']);
};
```

### Comparison to Modern Build Tools

**Webpack 5 equivalent**:
```javascript
// webpack.config.js
module.exports = {
    entry: './src/index.js',
    output: {
        filename: 'bundle.js',
        path: path.resolve(__dirname, 'dist')
    },
    module: {
        rules: [
            {
                test: /\.js$/,
                exclude: /node_modules/,
                use: 'babel-loader'
            },
            {
                test: /\.scss$/,
                use: ['style-loader', 'css-loader', 'sass-loader']
            }
        ]
    },
    plugins: [
        new MiniCssExtractPlugin(),
        new HtmlWebpackPlugin({ template: './src/index.html' })
    ]
};
```

**Vite equivalent** (modern, much faster):
```javascript
// vite.config.js
import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

export default defineConfig({
    plugins: [react()],
    build: {
        outDir: 'dist',
        minify: 'esbuild'
    }
});
```

---

## Comparison: AngularJS vs Modern Frameworks

### Technology Evolution

| Feature | AngularJS 1.5 (Current) | React 18 (Recommended) | Angular 17 | Vue 3 |
|---------|------------------------|------------------------|------------|-------|
| **Release Year** | 2016 | 2022 | 2023 | 2022 |
| **Status** | End of Life (2022) | Active | Active | Active |
| **Performance** | Moderate | Excellent | Excellent | Excellent |
| **Learning Curve** | Moderate | Moderate | Steep | Easy |
| **TypeScript** | Optional | Excellent | Required | Excellent |
| **Mobile** | Poor | Excellent | Good | Good |
| **SEO** | Poor (SPA only) | Excellent (SSR) | Good (SSR) | Good (SSR) |
| **Bundle Size** | ~150KB | ~40KB | ~130KB | ~30KB |
| **Hiring Pool** | Shrinking | Largest | Medium | Growing |

### Code Pattern Comparison

#### Data Binding

**AngularJS (Two-way binding)**:
```html
<input type="text" ng-model="vm.name" />
<p>Hello, {{ vm.name }}!</p>
```

**React (One-way binding)**:
```jsx
const [name, setName] = useState('');

<input type="text" value={name} onChange={e => setName(e.target.value)} />
<p>Hello, {name}!</p>
```

#### Lists

**AngularJS**:
```html
<div ng-repeat="property in vm.properties">
    <h3>{{ property.address }}</h3>
    <p>${{ property.rent }}</p>
</div>
```

**React**:
```jsx
{properties.map(property => (
    <div key={property.id}>
        <h3>{property.address}</h3>
        <p>${property.rent}</p>
    </div>
))}
```

#### Conditional Rendering

**AngularJS**:
```html
<div ng-if="vm.isLoading">Loading...</div>
<div ng-if="!vm.isLoading">Content</div>
```

**React**:
```jsx
{isLoading ? <div>Loading...</div> : <div>Content</div>}
```

### Migration Benefits

**Upgrading from AngularJS to React 18 + Next.js 14**:

| Benefit | Impact |
|---------|--------|
| **Performance** | 3-5x faster page loads |
| **SEO** | Server-side rendering, better search rankings |
| **Mobile** | Better mobile performance and experience |
| **Developer Experience** | Modern tooling, hot reload, better debugging |
| **Hiring** | 10x larger talent pool |
| **Bundle Size** | 70% smaller initial load |
| **Type Safety** | Full TypeScript support |
| **Testing** | Better testing tools (Jest, React Testing Library) |
| **Long-term Support** | Active development and security updates |

---

## Key Frontend Features

### Authentication Flow

1. User submits login form
2. AngularJS service sends credentials to `/api/Account/Login`
3. API returns JWT bearer token
4. Token stored in localStorage
5. Token included in all subsequent API requests via HTTP interceptor
6. UI-Router checks authentication on route changes

### File Upload

**Uses**: `ng-file-upload` library
```html
<input type="file" ngf-select ng-model="vm.files" multiple />
<button ng-click="vm.upload()">Upload</button>
```

### Google Maps Integration

**Uses**: `ngMap` directive
```html
<ng-map center="[{{vm.latitude}}, {{vm.longitude}}]" zoom="14">
    <marker position="[{{vm.latitude}}, {{vm.longitude}}]" title="{{vm.address}}"></marker>
</ng-map>
```

### Charts and Visualizations

**Uses**: ApexCharts
```javascript
vm.chartOptions = {
    series: [{
        name: 'Rent Collected',
        data: [1500, 1800, 1600, 2000]
    }],
    chart: {
        type: 'line',
        height: 350
    }
};
```

---

## Critical Issues with Current Frontend

### 1. AngularJS End of Life (2022)

- ❌ No security patches
- ❌ No bug fixes
- ❌ Shrinking developer pool
- ❌ Incompatible with modern libraries
- ❌ Poor performance on mobile

### 2. No Server-Side Rendering

- ❌ Poor SEO (search engines struggle with SPA)
- ❌ Slow initial page load
- ❌ No social media preview cards

### 3. Large Bundle Size

- Current: ~150KB framework + ~200KB app code
- Modern equivalent: ~40KB React + ~100KB app code
- **Result**: 50% smaller bundles with modern frameworks

### 4. Poor Mobile Performance

- AngularJS digest cycle expensive on mobile CPUs
- Modern frameworks (React, Vue) use virtual DOM for better performance

---

## Document Information

**Document Version**: 1.0
**Last Updated**: October 4, 2025
**Related Documents**:
- [System Overview](../01-overview/system-overview.md)
- [API Services](../04-backend/api-services.md)
- [Code Examples](../10-development/code-examples.md)
