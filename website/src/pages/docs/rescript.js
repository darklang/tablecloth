import * as React from 'react';
import { graphql } from 'gatsby';
import { Helmet } from 'react-helmet';

import { SyntaxProvider } from '../../components/Syntax';
import DocsView from '../../views/docs-view';

export default ({ data }) => {
  return (
    <SyntaxProvider defaultSyntax="reason">
      <Helmet>
        <title>Tablecloth: Rescript Documentation</title>
      </Helmet>
      <DocsView language="rescript" data={data} />
    </SyntaxProvider>
  );
};

export const pageQuery = graphql`
  query {
    site {
      siteMetadata {
        docsLocation
      }
    }
    odocModel(id: { eq: "odoc-model-rescript" }) {
      internal {
        content
      }
    }
  }
`;
