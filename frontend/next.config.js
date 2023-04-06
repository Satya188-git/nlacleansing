/* eslint-disable */
const withPlugins = require('next-compose-plugins')
const withAntdLess = require('next-plugin-antd-less')
const { getThemeVariables } = require('antd/dist/theme')
const darkBlue = '#031627'
const secondaryDarkBlue = '#0E263B'
const selectedRed = '#CB154A'

const pluginAntdLess = withAntdLess({
  modifyVars: {
    ...getThemeVariables({
      dark: true,
      compact: true,
    }),
    '@primary-color': '#04f',
    '@body-background': secondaryDarkBlue,
    '@component-background': darkBlue,
    '@layout-body-background': secondaryDarkBlue,
    '@layout-footer-background': darkBlue,
    '@layout-sider-background': darkBlue,
    '@menu-dark-bg': 'transparent',
    '@menu-bg': 'transparent',
    '@menu-dark-selected-item-icon-color': selectedRed,
    '@menu-dark-item-hover-bg': secondaryDarkBlue,
    '@menu-dark-item-active-bg': secondaryDarkBlue,
  },
})

module.exports = withPlugins([[pluginAntdLess]], {
  webpack(config) {
    return config
  },
  trailingSlash: true,
  staticPageGenerationTimeout: 1000,
  experimental: {
    images: {
      unoptimized: true,
    },
  },
  images: {
    unoptimized: true,
  },
  async redirects() {
    return [
      {
        source: '/',
        destination: '/dashboard',
        permanent: true,
      },
    ]
  },
})
