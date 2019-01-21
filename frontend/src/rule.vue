<script lang='coffee'>
export default
  required: (attr) -> ->
    attr.required || 'Required'
  email: (attr) -> ->
    attr.email || 'Invalid email address'
  url: (attr) -> ->
    attr.url || 'Invalid URL'
  minLength: (attr, msg="At least #{attr.$params.minLength.min} characters") -> ->
    attr.minLength || msg
  match: (attr1, attr2) -> ->
    attr1.$model == attr2.$model || 'Mismatch password'
</script>
