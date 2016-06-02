--------------------------------------------------------------------------------
{-# LANGUAGE OverloadedStrings #-}
-- {-# LANGUAGE FlexibleContexts #-}

import           Hakyll
import           Control.Monad          (forM,forM_)
import           Data.Char              (toLower)
import           Data.List              (sortBy, isInfixOf, isPrefixOf, tails, findIndex)
import           Data.Monoid            (mappend,(<>),mconcat)
import           Data.Ord               (comparing)
import           System.Locale          (defaultTimeLocale)
import           System.FilePath.Posix  (takeBaseName,takeDirectory
                                         ,(</>),splitFileName)


--------------------------------------------------------------------------------
main :: IO ()
main = hakyll $ do
    match "images/*" $ do
        route   idRoute
        compile copyFileCompiler

    match "css/*" $ do
        route   idRoute
        compile compressCssCompiler

    match (fromList ["about/index.html", "software/index.html"]) $ do
        route   niceRoute
        compile $ pandocCompiler
            >>= loadAndApplyTemplate "templates/default.html" defaultContext
            >>= relativizeUrls

    match "blog/**/*.markdown" $ do
        route $ niceRoute
        compile $ pandocCompiler
          >>= saveSnapshot "snippet"
          >>= loadAndApplyTemplate "templates/post.html"    postCtx
          >>= loadAndApplyTemplate "templates/default.html" postCtx
          -- >>= removeIndexHtml
          >>= relativizeUrls

    create ["blog/archive/index.html"] $ do
        route idRoute
        compile $ do
            posts <- recentFirst =<< loadAllSnapshots "public/blog/**/*.markdown" "snippet"
            let archiveCtx =
                    listField "posts" snippetCtx (return posts) `mappend`
                    constField "title" "Archives"               `mappend`
                    defaultContext
            makeItem ""
                >>= loadAndApplyTemplate "templates/archive.html" archiveCtx
                >>= loadAndApplyTemplate "templates/default.html" archiveCtx
                >>= relativizeUrls

    match "index.html" $ do
        route idRoute
        compile $ do
            posts <- fmap (take 7) . recentFirst =<< loadAllSnapshots "blog/**/*.markdown" "snippet"
            let indexCtx =
                  listField "posts" snippetCtx (return posts)                `mappend`
                  constField "title" "Quod erat faciendum - Brendan Ribera" `mappend`
                  defaultContext

            getResourceBody
                >>= applyAsTemplate indexCtx
                >>= loadAndApplyTemplate "templates/default.html" indexCtx
                >>= relativizeUrls

    match "templates/*" $ compile templateBodyCompiler


--------------------------------------------------------------------------------

postCtx :: Context String
postCtx =
  dateField "date" "%B %e, %Y" `mappend`
  defaultContext

-- replace a foo/bar.md with foo/index.html
-- this way the url looks like: foo/bar in most browsers
niceRoute :: Routes
niceRoute = customRoute createIndexRoute
  where
    createIndexRoute ident = takeDirectory p </> "index.html"
      where p = toFilePath ident

-- -- replace url of the form foo/bar/index.html by foo/bar
-- removeIndexHtml :: Item String -> Compiler (Item String)
-- removeIndexHtml item = return $ fmap (withUrls removeIndexStr) item
--   where
--     removeIndexStr :: String -> String
--     removeIndexStr url = case splitFileName url of
--         (dir, "index.html") | isLocal dir -> dir
--         _                                 -> url
--         where isLocal uri = not (isInfixOf "://" uri)


-- inspired by https://github.com/dannysu/hakyll-blog/blob/a1a7533ee0dcb8bc61511783c4702b1fb4925739/site.hs#L167
snippetCtx :: Context String
snippetCtx =
  Main.snippetField <> postCtx

snippetField :: Context String
snippetField = field "snippet" $ \item -> do
    body <- itemBody <$> loadSnapshot (itemIdentifier item) "snippet"
    return $ (maxLengthSnippet . compactSnippet) body
  where
    maxLengthSnippet :: String -> String
    maxLengthSnippet s = unwords (take 60 (words s))
    compactSnippet :: String -> String
    compactSnippet = (replaceAll "<[^>]*>" (const ""))
