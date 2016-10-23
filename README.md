# redirect-checker
checking list of redirect with user-agent

## Usage

- ``` stack build ```
- ``` stack exec checker-exe user-agent filename ```

### Example

#### PC to SP
- ``` stack exec checker-exe iPhone sp.txt ```
- sp.txt [from to]
  ```
  http://example.com http://example.com/sp
  http://sample.jp http://sample.jp/sp
  ...
  ```
- result
  - success
  ```
  All OK!
  ```
  - fail
  ```
  error message
  error message
  ...
  ```

#### SP to PC
- ``` stack exec checker-exe Macintosh pc.txt ```
- pc.txt [from to]
  ```
  http://example.com/sp http://example.com
  http://sample.jp/sp http://sample.jp
  ...
  ```
- result: Same as PC to SP
