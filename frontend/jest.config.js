module.exports = {
  preset: 'jest-expo',
  testEnvironment: 'jsdom',
  transformIgnorePatterns: [
    "node_modules/(?!((jest-)?react-native|@react-native|expo(nent)?|@expo(nent)?\\/.*|@expo-google-fonts\\/.*|@react-navigation\\/.*|@react-native-community\\/.*|react-native-svg|unimodules-.*|@unimodules\\/.*|@gorhom\\/.*|@rneui\\/.*))"
  ],
  moduleFileExtensions: ['ts', 'tsx', 'js', 'jsx', 'json', 'node'],
  moduleNameMapper: {
    '^@/(.*)$': '<rootDir>/src/$1'
  },
  setupFilesAfterEnv: ['@testing-library/jest-native/extend-expect'],
  // setupFiles: ['<rootDir>/jest-expo-setup.js'],
};