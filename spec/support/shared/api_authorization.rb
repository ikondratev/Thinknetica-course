shared_examples_for 'API autorizable' do
  context 'unauthorized' do
    it 'returns 401 status if there is no access_token' do
      do_request(method, api_path, headers: headers)
      expect(response.status).to eq 401
    end

    it 'returns 401 status if access_token is invalid' do
      do_request(method, api_path, params: { access_token: '12345' }, headers: headers)
      expect(response.status).to eq 401
    end
  end
end

shared_examples 'Returns list of objects' do |size, json_objectable|
  let(:json_objects) { send(json_objectable) }

  it "returns list of objects" do
    expect(json_objects.size).to eq size
  end
end

shared_examples 'Returns response status' do |status|
  it "returns status #{status}" do
    expect(response.status).to eq status
  end
end

shared_examples 'Returns all public fields' do |json_objectable, objectable|
  let(:json_object) { send(json_objectable) }
  let(:object) { send(objectable) }

  it "return all public fields for objects" do
    items.each do |attr|
      expect(json_object[attr]).to eq object.send(attr).as_json
    end
  end
end
