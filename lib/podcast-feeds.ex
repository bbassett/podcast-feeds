defmodule PodcastFeeds do

  # RSS2 image element
  defmodule Image do
    defstruct title: nil,
              url: nil,
              link: nil,
              width: nil,
              height: nil,
              description: nil
  end

  # RSS2 enclosure element
  defmodule Enclosure do
    defstruct url: nil,
              length: nil,
              type: nil
  end

  # Feed Meta / Channel data
  defmodule Meta do
    defstruct title: nil,
              link: nil,
              description: nil,
              author: nil,
              language: nil,
              copyright: nil,
              publication_date: nil,
              last_build_date: nil,
              generator: nil,
              categories: [],
              cloud: nil,
              ttl: nil,
              managing_editor: nil,
              web_master: nil,
              skip_hours: [],
              skip_days: [],
              image: nil,
              itunes: nil,
              atom_links: [],
              contributors: []
  end

  # Feed Entry / Episode / Item data
  defmodule Entry do
    defstruct title: nil,
              link: nil,
              description: nil,
              author: nil,
              categories: [],
              comments: nil,
              enclosure: nil,
              guid: nil,
              publication_date: nil,
              source: nil,
              itunes: nil,
              chapters: [],
              atom_links: [],
              contributors: [],
              content_encoded: nil
  end

  # A Feed
  defmodule Feed do
    defstruct meta: nil, 
              entries: [],
              namespaces: []
  end



  # rss cloud element
  defmodule Cloud do
    defstruct domain: nil,
              port: nil,
              path: nil,
              register_procedure: nil,
              protocol: nil
  end





  def parse(xml) do
    xml
    |> detect_parser
    |> parse_document
  end

  defp parse_document({:ok, parser, document}) do
    state = parser.parse_feed(document)
    {:ok, state.feed}
  end

  # this matches errors from detect_parser
  defp parse_document(other), do: other

  defp detect_parser(document) do
    cond do
      PodcastFeeds.Parsers.RSS2.valid?(document) -> {:ok, PodcastFeeds.Parsers.RSS2, document}
      PodcastFeeds.Parsers.Atom.valid?(document) -> {:ok, PodcastFeeds.Parsers.Atom, document}
      true -> {:error, "Unknown feed format"}
    end
  end

  # def parse_file(filename) do
  #   File.stream!(filename, [], @chunk_size)
  #   |> parse_stream
  # end

  # def parse_stream(stream) do
  #   stream
  #   |> PodcastFeeds.Parsers.RSS2.parse_feed
  #   |> (fn(state)-> 
  #     {:ok, state.feed} 
  #   end).()
  # end


end
