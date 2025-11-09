'use client';

import { login, signup } from '@/lib/actions/auth';
import { useState } from 'react';

export default function LoginPage() {
  const [error, setError] = useState('');
  const [isSignup, setIsSignup] = useState(false);

  async function handleSubmit(formData) {
    setError('');
    const action = isSignup ? signup : login;
    const result = await action(formData);
    if (result?.error) {
      setError(result.error);
    }
  }

  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50">
      <div className="max-w-md w-full space-y-8 p-8 bg-white rounded-lg shadow-md">
        <div>
          <h2 className="text-center text-3xl font-bold text-gray-900">
            FlexLite PLM
          </h2>
          <p className="mt-2 text-center text-sm text-gray-600">
            {isSignup ? 'Create a new account' : 'Sign in to your account'}
          </p>
        </div>

        <form className="mt-8 space-y-6" action={handleSubmit}>
          {error && (
            <div className="rounded-md bg-red-50 p-4">
              <div className="text-sm text-red-800">{error}</div>
            </div>
          )}

          <div className="rounded-md shadow-sm -space-y-px">
            <div>
              <label htmlFor="email" className="sr-only">
                Email
              </label>
              <input
                id="email"
                name="email"
                type="email"
                autoComplete="email"
                required
                className="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-t-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="Email address"
              />
            </div>
            <div>
              <label htmlFor="password" className="sr-only">
                Password
              </label>
              <input
                id="password"
                name="password"
                type="password"
                autoComplete="current-password"
                required
                className="appearance-none rounded-none relative block w-full px-3 py-2 border border-gray-300 placeholder-gray-500 text-gray-900 rounded-b-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm"
                placeholder="Password"
              />
            </div>
          </div>

          <div>
            <button
              type="submit"
              className="group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
            >
              {isSignup ? 'Sign up' : 'Sign in'}
            </button>
          </div>

          <div className="text-center">
            <button
              type="button"
              onClick={() => {
                setIsSignup(!isSignup);
                setError('');
              }}
              className="text-sm text-indigo-600 hover:text-indigo-500"
            >
              {isSignup ? 'Already have an account? Sign in' : 'Don&apos;t have an account? Sign up'}
            </button>
          </div>
        </form>

        <div className="mt-4 p-4 bg-blue-50 rounded-md">
          <p className="text-xs text-blue-800">
            <strong>Local Development:</strong> Use any email and password to sign up (local Supabase doesn&apos;t send real emails)
          </p>
        </div>
      </div>
    </div>
  );
}
