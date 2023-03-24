
This is a [Next.js](https://nextjs.org/) + TypeScript project bootstrapped with [`create-next-app`](https://github.com/vercel/next.js/tree/canary/packages/create-next-app).

  

## Getting Started

  

Download .env files from `Amazon S3 > Buckets > processedbucketsociallistening > secrets ` and move the files to the root of the `/frontend` directory

  

Install node packages in terminal inside `frontend/` directory:

```bash

yarn

# or

npm install

```

Then, run the development server:

  

```bash

yarn dev

# or

npm run dev

```

  

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result. NextJS auto-updates as you edit any files.

  

## Project Structure

  

#### Apps

2 apps in 1 project. Can navigate the apps using the navbar.

1. Customer Call Center (CCC)

2. Social Listening

#### Continuing Work

- [ ] Incorporate Sempra POC @innovation-toolkit and consuming components from the library

- [ ] `CallInsights_all_fe_final_.json` Split up <10MB per file in `final_insights` S3 bucket and join all small files together client side

- [ ] Export PDF button for end-user to download the detailed report from a specific date range

#### AWS

Link - https://sempra-aws.awsapps.com/start#/
* Environment name - `ent-eqmie-dev` 

#### Steps to Deployment Process
Dev Link - https://d2qx4ixe9l327n.cloudfront.net/

1. Run `yarn deploy:dev` to create a static `out` directory
2. Delete all existing files/folders in S3 bucket `hostingbucketsociallistening` EXCEPT `/secrets`
3. Copy all files/folders inside `out` directory and upload in `hostingbucketsociallistening`. Once upload is finished, Cloudfront should automatically already pick up on these changes. If you don't see the changes, maybe wait for 1-2 minutes. 

#### Data

* CCC Data is being pulled from local json file `CallInsights_all_fe_final_.json` due to huge file size (~50MB). File limit of ~10MB for a `GET` API Call via API Gateway.

* Social Listening Data is being pulled from AWS S3 `processedbucketsociallistening` bucket from the file `scg_output.json` and `sdge_output.json` to separate out the two partner logic

  

#### Directories & Files

* Navbar points to routes demonstrating Social Listening + Customer Call Center capabilities. Both apps are currently combined in this repository building on top of reusable components from innovation toolkit and React ANTD.

* `pages/_app.tsx` = main application wrapper. Any components persisting across all pages should be here such as Navbars, Footers, Siders etc.

* `pages/index.tsx` = mainly used to render our component tree

* `pages/` = contain all API routes

[API routes](https://nextjs.org/docs/api-routes/introduction) can be accessed on [http://localhost:3000/api/hello](http://localhost:3000/api/hello). This endpoint can be edited in `pages/api/hello.js`.

The `pages/api` directory is mapped to `/api/*`. Files in this directory are treated as [API routes](https://nextjs.org/docs/api-routes/introduction) instead of React pages.

* `components/` = contain all components

* `context/` = contain global state management using Context API created by React team

* `helpers/` = contain any utility helpers such as functions, global constants etc.

* `images/` = contain any project images

* `public/` = contain favicon

* `stories/` = contain all storybook components

* `styles/` = contain all NextJS out of the box CSS

* `types/` = contain all TypeScript types used to be consumed by 2+ React Components

  

#### Coding Conventions

* `.tsx` = for rendering React Components

* `.ts` = for non-components

* `index.ts` = to batch export and expose objects to make it easier to import in other files. Each subfolder typically has one.

* Use `interface` over `type` for type declarations

  

#### Styling

* Use `React ANT Design` UI Component Library with custom themed variable configurations inside `next.config.js`. More granular override-able themed variables can be found [HERE](https://github.com/ant-design/ant-design/blob/master/components/style/themes/default.less).

* Use `dark` theme aligned with designs found [HERE](https://www.figma.com/file/F7k7cqKqJxurjvhkCsdaxi/Customer-Insights-Dashboard?node-id=0%3A1).

* Use `styled-components` as opposed to CSS to style components in a modular fashion.

  

## Learn More

  

To learn more about Next.js, take a look at the following resources:

  

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.

- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

  

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js/) - your feedback and contributions are welcome!