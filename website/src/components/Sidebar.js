import React, { useState } from 'react';
import { useStaticQuery, graphql } from 'gatsby';
import _ from 'lodash';
import styled, { css, createGlobalStyle } from 'styled-components';
import { colors, dimensions } from '../theme';
import { Link } from './Link';

const TreeNode = ({ items }) => {
  return (
    <ul className="sideBarItems">
      {items.map(({ active, title, url, items: subItems }) => {
        const hasChildren = subItems.length !== 0;
        return (
          <li className={`item${active ? ' active' : ''}`} key={url}>
            <Link to={url}>{title}</Link>
            {hasChildren ? <TreeNode items={subItems} /> : null}
          </li>
        );
      })}
    </ul>
  );
};

let generateItems = (baseUrl, items = []) =>
  items.map(item => {
    let url = `${baseUrl}${item.url}`;
    return {
      title: item.title,
      url,
      items: generateItems(url, item.items),
    };
  });

export const Sidebar = ({ location }) => {
  const { allMdx } = useStaticQuery(graphql`
    query {
      allMdx {
        edges {
          node {
            fields {
              url
              title
            }
            tableOfContents
            frontmatter {
              order
            }
          }
        }
      }
    }
  `);
  let pages = _.sortBy(allMdx.edges, edge =>
    Number(edge.node.frontmatter.order || '999'),
  );

  return (
    <div
      className="Sidebar"
      css={css`
        background-color: ${({ theme }) => theme.sidebar.background};
        color: ${({ theme }) => theme.navbar.background};
        padding-top: 3rem;
        padding-bottom: 3rem;
        width: 100%;
        height: 100vh;
        overflow-y: auto;

        .sideBarItems {
          padding: 0;
          list-style: none;

          .item {
            a {
              color: ${({ theme }) => theme.sidebar.text};
              font-size: 14px;
              font-weight: 500;
              line-height: 1.5;
              padding: 14px 20px;
              display: flex;
              align-items: center;
              position: relative;
              width: 100%;
              &:hover {
                background-color: ${({ theme }) =>
                  theme.sidebar.hover};
                color: ${({ theme }) => theme.sidebar.activeText};
              }
            }

            .sideBarItems {
              margin-left: 20px;
              border-left: 1px solid ${colors.grey.dark};
            }

            &.active {
              > a {
                background-color: ${({ theme }) =>
                  theme.sidebar.activeBackground};
                color: ${({ theme }) => theme.sidebar.activeText};
              }
            }
          }
        }

        @media only screen and (min-width: 767px) {
          width: ${dimensions.leftSidebarWidth}px;
        }
      `}
    >
      <TreeNode
        items={pages.map(({ node: { fields, tableOfContents } }) => {
          let active = fields.url === location.pathname;
          return {
            active,
            title: fields.title,
            url: fields.url,
            items: active
              ? generateItems(fields.url, tableOfContents.items)
              : [],
          };
        })}
      />
    </div>
  );
};
